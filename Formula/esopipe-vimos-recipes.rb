class EsopipeVimosRecipes < Formula
  desc "ESO VIMOS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/vimos/vimos-kit-4.1.13-3.tar.gz"
  sha256 "602403ba51f2f9ef2685e65e036d33cb9e0030d17b99a1265347394db587de9d"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?vimos-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-vimos-recipes-4.1.13-3_1"
    sha256 cellar: :any,                 arm64_tahoe:   "7275dac2eed59467fbf685dc80ea784c99633f0826537567ef303cef0a125c24"
    sha256 cellar: :any,                 arm64_sequoia: "d686e7ec5b1641353e92d3a7b8c09a498dd25bb53f404212a9fc9c80c78316ec"
    sha256 cellar: :any,                 arm64_sonoma:  "c881b73f0e3611fe66194f0d0207ecdf9d9919cede402ec2a2091f05836e1820"
    sha256 cellar: :any,                 sonoma:        "0f1b22b392dcc7fb784631e6ebf4a024e48f04e2c30bb0b97f34a9698242dcd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87cdb222b59b222388990fd7bcb403c0efc7db19c202deb647a010831677d42"
  end

  def name_version
    "vimos-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
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
