class EsopipeXshooRecipes < Formula
  desc "ESO XSHOOTER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/xshooter/xshoo-kit-3.6.8-6.tar.gz"
  sha256 "999305051d41378f1eb6816cfe8140f9ed6df5b159a5c7767e1cdaa49a441516"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?xshoo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-xshoo-recipes-3.6.8_4"
    sha256 cellar: :any,                 arm64_sequoia: "b6a5d2d4658c31c5e1d88037088e11094053db90f86403ea2d9b097f3b614ef5"
    sha256 cellar: :any,                 arm64_sonoma:  "23659db89ac4a5722cda372217a173a1cb9e2f4c5bc69929ccda9f3c56e29d7b"
    sha256 cellar: :any,                 ventura:       "e402b7a8150dd3dfc8c4707be81c35fd2f071646bc0166e55221491fbdc04e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d1984cc8df2a5f95d8143d802023cafb488c380b7ac3f5a5ef2e394737f9aa"
  end

  def name_version
    "xshoo-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "telluriccorr"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}",
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
    assert_match "xsh_mdark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page xsh_mdark")
  end
end
