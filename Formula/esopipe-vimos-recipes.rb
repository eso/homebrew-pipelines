class EsopipeVimosRecipes < Formula
  desc "ESO VIMOS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/vimos/vimos-kit-4.1.12-6.tar.gz"
  sha256 "0f78a74443d7f6b956f050cad78301e8e8db7a11ab7dfc8610668d4de65e5e3e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?vimos-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-vimos-recipes-4.1.12-5"
    sha256 cellar: :any,                 arm64_sequoia: "fb628ca1f6d672c7a5953210e524ea40f0776d3273e114bcb31551b29d1c6164"
    sha256 cellar: :any,                 arm64_sonoma:  "df575a1c348306b268f0afcea206591f1f5f3b522ee0dbe620f24278d283d749"
    sha256 cellar: :any,                 ventura:       "2e03d070e5f9bed171e8a2be27272efc0cb5bd7018c6993a357de37280b22212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "940a4f2c9cc2681ea6a4ef13b535476550a42ffc33de11621dc2296d85070f85"
  end

  def name_version
    "vimos-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}"
      system "make", "install"
    end
  end

  def post_install
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"
    workflow_dir_1.glob("*.xml").each do |workflow|
      ohai "Updating #{workflow}"
      if workflow.read.include?("CALIB_DATA_PATH_TO_REPLACE")
        inreplace workflow, "CALIB_DATA_PATH_TO_REPLACE", HOMEBREW_PREFIX/"share/esopipes/datastatic"
      end
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      end
      if workflow.read.include?("$ROOT_DATA_DIR/reflex_input")
        inreplace workflow, "$ROOT_DATA_DIR/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "vimos_ima_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page vimos_ima_dark")
  end
end
