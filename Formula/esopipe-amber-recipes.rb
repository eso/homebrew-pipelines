class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-16.tar.gz"
  sha256 "78ced7453b4da828b532604e1d2a4d0c58cd58a843be9127eef5905602e19c1f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-16"
    sha256 cellar: :any, arm64_tahoe:   "f5025cb9786807e2e28082811a19f5e68b8442ad727f526a99cb36484e58bbec"
    sha256 cellar: :any, arm64_sequoia: "4886470f7d339708cde1254ba8648ea5676abc5451bbe653ffbb3cdf2349dd5d"
    sha256 cellar: :any, arm64_sonoma:  "b593720b4af00b01527e46080aeb18546bbd738815c11cae10fc777b7d05302d"
    sha256 cellar: :any, sonoma:        "64a0e22d1ece94b46d31003b12b03310c8280c10480b424259c9ccfd9c14073e"
    sha256 cellar: :any, x86_64_linux:  "db02df9decffc18c20254ba5107d471113d274305aa2971b1a95578932cd0379"
  end

  def name_version
    "amber-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "fftw"
  depends_on "gsl"
  depends_on "libcext"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
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
