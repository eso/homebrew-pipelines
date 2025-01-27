class WcslibAT83 < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/people/mcalabre/WCS/wcslib-8.3.tar.bz2"
  sha256 "431ea3417927bbc02b89bfa3415dc0b4668b0f21a3b46fb8a3525e2fcf614508"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/wcslib@8.3-8.3"
    sha256 cellar: :any,                 arm64_sequoia: "334ec58d019d981953d2d2c530c7e4129253d5ac189343fdfeeb5550263a5a7c"
    sha256 cellar: :any,                 arm64_sonoma:  "5d3dd9e3af3239289c8c353f133c8c8caca98e8f480afc17425bb2c8412faccb"
    sha256 cellar: :any,                 ventura:       "ecf0ebfddff602b48472176953471d427a4a220ad6345f29bdaaa701f065b799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f32a6363788d694a7515426fbd42b7e41ac288406239777e964f04143a6f13a"
  end

  depends_on "cfitsio@4.5.0"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cfitsiolib=#{Formula["cfitsio@4.5.0"].opt_lib}",
                          "--with-cfitsioinc=#{Formula["cfitsio@4.5.0"].opt_include}",
                          "--without-pgplot",
                          "--disable-fortran"
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + (" "*20) + "T / comment" + (" "*40) + "END" + (" "*2797)
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
