class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-9.tar.gz"
  sha256 "7b4339232d97267b23aa09e7718599edfeec273cb7f1a3f7821888a217946a4f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-8_2"
    sha256 cellar: :any,                 arm64_sequoia: "12269b766f6c06dc52ff22d2f1df340526d9b635a335d520160a8e0c7b2bd081"
    sha256 cellar: :any,                 arm64_sonoma:  "d8e397b763b5c2d35bf7c64bc53a005a41a484dc65f1decb93b9784b405bbd51"
    sha256 cellar: :any,                 ventura:       "1f02e7b10f67a4b3c74742569d2caa39b4a4f72620aa60463b0d40ff4fa3520c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc1a7e867bd8a8c85067e1c17316a66652235173416a97f943176a6a8ec0b68"
  end

  def name_version
    "amber-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "fftw"
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

  test do
    assert_match "amber_calibrate -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page amber_calibrate")
  end
end
