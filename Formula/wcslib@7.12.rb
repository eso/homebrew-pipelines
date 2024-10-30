class WcslibAT712 < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/wcslib/wcslib-7.12.tar.bz2"
  sha256 "9cf8de50e109a97fa04511d4111e8d14bd0a44077132acf73e6cf0029fe96bd4"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/wcslib@7.12-7.12_3"
    sha256 cellar: :any,                 arm64_sequoia: "3c5093f452e99d9bb132b0119b60359aaa60c3b2adcefdc6b1f73ba561afd702"
    sha256 cellar: :any,                 arm64_sonoma:  "5f776fb906c429bd271c23faa33be18b342c64fe4f0c02302ff66b023dc62e11"
    sha256 cellar: :any,                 ventura:       "838ce1232740ca69e5af046254ed6c90f595dacb1f1e2e5432eaa7aeff0a2a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44501fba394ae4d5d64dc243bdad4d9072818a64ef09695c064ebb26d59652e9"
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
