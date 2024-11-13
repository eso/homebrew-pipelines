class EsopipeEsotkRecipes < Formula
  desc "ESO ESOTK instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/esotk/esotk-kit-0.9.7-1.tar.gz"
  sha256 "2d2db2d352b146b1f7c683cd1ee107bb5275e597ef412474ac4d39163fb6ce36"
  license "GPL-2.0-or-later"
  revision 3

  def name_version
    "esotk-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?esotk-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-esotk-recipes-0.9.7-1_2"
    sha256 cellar: :any,                 arm64_sequoia: "ae7ce3ab8200d67c9db03789811504efba339b186104c8b1dacb408116399d23"
    sha256 cellar: :any,                 arm64_sonoma:  "94cb289fa925426549625a5b35bc09d390a2c3f2e8946d0182b35c6c73c992bd"
    sha256 cellar: :any,                 ventura:       "991d3f92d61fcd5cae8963f8886479c40540ea5ec30397727d2f8d1fecce041b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee3c6870fe64106846d03eb0b6335c8672c6db48a33186ebeea3903f288f8092"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  uses_from_macos "curl"

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["fftw@3.3.9"].opt_lib}"
    ENV.prepend "LDFLAGS", "-L#{Formula["wcslib@7.12"].opt_lib}"
    ENV.prepend "LDFLAGS", "-L#{Formula["cfitsio@4.2.0"].opt_lib}"

    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure",
             "--prefix=#{prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}",
             "--with-erfa=#{Formula["erfa"].prefix}",
             "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
    end
  end

  def post_install
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"
    workflow_dir_1.glob("*.xml").each do |workflow|
      ohai "Updating [ROOT|CALIB|RAW]_DATA_DIR in #{workflow}"
      inreplace workflow, "CALIB_DATA_PATH_TO_REPLACE", HOMEBREW_PREFIX/"share/esopipes/datastatic"
      inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      inreplace workflow, "$ROOT_DATA_DIR/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "esotk_spectrum1d_combine -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page esotk_spectrum1d_combine")
  end
end
