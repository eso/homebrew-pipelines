class WcslibAT712 < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/wcslib/wcslib-7.12.tar.bz2"
  sha256 "9cf8de50e109a97fa04511d4111e8d14bd0a44077132acf73e6cf0029fe96bd4"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/wcslib@7.12-7.12_2"
    sha256 cellar: :any,                 arm64_sonoma: "a4bfa83190f8e28128540575b83988da794f5458b1549cbcc7392504ed39ae5e"
    sha256 cellar: :any,                 ventura:      "2f9a2af79facb1cd5959263866d411f2b0abd86dd6c830b92dabc27045299881"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d1edf2d82be34477dfab5a4e1aaaccd9131b34e7dc8ba4b0109ca53e848d3efe"
  end

  keg_only :versioned_formula

  depends_on "cfitsio@4.2.0"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cfitsiolib=#{Formula["cfitsio@4.2.0"].opt_lib}",
                          "--with-cfitsioinc=#{Formula["cfitsio@4.2.0"].opt_include}",
                          "--without-pgplot",
                          "--disable-fortran"
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + (" "*20) + "T / comment" + (" "*40) + "END" + (" "*2797)
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
