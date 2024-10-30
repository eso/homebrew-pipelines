class EsopipeEsotkRecipes < Formula
  desc "ESO ESOTK instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/esotk/esotk-kit-0.9.7-1.tar.gz"
  sha256 "2d2db2d352b146b1f7c683cd1ee107bb5275e597ef412474ac4d39163fb6ce36"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?esotk-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esopipe-esotk-recipes-0.9.7-1_1"
    sha256 cellar: :any,                 arm64_sonoma: "c7709bbebdc05685136b2edc24b4da58927843fc98329bf8c531d10d88b36008"
    sha256 cellar: :any,                 ventura:      "508820d79111e09d66f732a99fca464726bbc1961291db032e10b01f0080bb76"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "60b2c7dcf2480ea71401012a877c3be9f8f2869630d506264acd08c796e514f7"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "curl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["fftw@3.3.9"].opt_lib}"
    ENV.prepend "LDFLAGS", "-L#{Formula["wcslib@7.12"].opt_lib}"
    ENV.prepend "LDFLAGS", "-L#{Formula["cfitsio@4.2.0"].opt_lib}"

    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "esotk-#{version_norevision}.tar.gz"
    cd "esotk-#{version_norevision}" do
      system "./configure",
             "--prefix=#{prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}",
             "--with-erfa=#{Formula["erfa"].prefix}",
             "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
    end
  end

  test do
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "esotk_spectrum1d_combine -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page esotk_spectrum1d_combine")
  end
end
