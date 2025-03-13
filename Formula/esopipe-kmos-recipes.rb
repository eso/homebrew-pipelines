class EsopipeKmosRecipes < Formula
  desc "ESO KMOS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/kmos/kmos-kit-4.5.1.tar.gz"
  sha256 "da1c7c61454e2f3c0ac858aaf66a40ff9c3124a1634eef4906bbb8d8365746c2"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?kmos-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-kmos-recipes-4.4.8-7"
    sha256 cellar: :any,                 arm64_sequoia: "79f2721441f3e09e476caca19be7b3618c9d13ba4c7cd9baf08c321e14944865"
    sha256 cellar: :any,                 arm64_sonoma:  "099cb204e98bbc7ff80e440e35ed9a36f0bab050fe602efc1291988dc01f3b08"
    sha256 cellar: :any,                 ventura:       "8f06780b7e7f4ef71d4a0a97ed10c024ca1a0151dec516c0647a6b9797780ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c775bfb2a47bc068fe936b86584d3a9963cf09486ef0d189436a368e83ccb64"
  end

  def name_version
    "kmos-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl"
  depends_on "esorex"
  depends_on "telluriccorr"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}"
      system "make", "install"
      rm bin/"kmos_calib.py"
      rm bin/"kmos_verify.py"
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
    assert_match "kmos_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page kmos_dark")
  end
end
