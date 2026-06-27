class EsopipeSinfoRecipes < Formula
  desc "ESO SINFONI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sinfoni/sinfo-kit-3.3.6-12.tar.gz"
  sha256 "a5f76ca81462d3587217cad6de4f6904c0c2eee29776753e10638c2edf742827"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sinfo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-sinfo-recipes-3.3.6-12"
    sha256 cellar: :any, arm64_tahoe:   "d6e65a3573b593c2d9a70f316289d54f7d6cc8beb04aaad4752a2982f5b841ea"
    sha256 cellar: :any, arm64_sequoia: "d9cab47aaab611cabb38cf2628a9efd4c9af0ac3f59abd2f87e196c654d05a8c"
    sha256 cellar: :any, arm64_sonoma:  "3e75510100753862154b5bc99910145124b1d6e87107c1ac5715e6e03817a869"
    sha256 cellar: :any, sonoma:        "fae7c4e9fd4ebdc7cd1cb589acaa902a1f1d3f3ac2b94d210b9f2918259f45b4"
    sha256 cellar: :any, x86_64_linux:  "f2b8b7150aeb8f0c3ced350c70263635776c30e5555088bf3d8dfdef8125cf6e"
  end

  def name_version
    "sinfo-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "libcext"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
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
    assert_match "sinfo_rec_mdark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page sinfo_rec_mdark")
  end
end
