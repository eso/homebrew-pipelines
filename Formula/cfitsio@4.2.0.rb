class CfitsioAT420 < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.2.0.tar.gz"
  sha256 "eba53d1b3f6e345632bb09a7b752ec7ced3d63ec5153a848380f3880c5d61889"
  license "CFITSIO"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/cfitsio@4.2.0-4.2.0_1"
    sha256 cellar: :any,                 arm64_sequoia: "f2549f852e5b85258bef12a26c1c6684d3f95c8a32bf13f454a2f5e7aa9af498"
    sha256 cellar: :any,                 arm64_sonoma:  "6197ead536490170a7dcdaab291905615a7e940f0d819e2a56af5d9aa068db82"
    sha256 cellar: :any,                 ventura:       "64e470a67f23981c596ea63fa23de3e1e292ca84f2f0a4e8245dd3e054e02520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa2ef7284df3a8f7cac8719e2d27aa435238ff6178a4f597d490c085410359f4"
  end

  keg_only :versioned_formula

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-reentrant"
    system "make", "shared"
    system "make", "install"
    (pkgshare/"testprog").install Dir["testprog*"]
  end

  test do
    cp Dir["#{pkgshare}/testprog/testprog*"], testpath
    system ENV.cc, "testprog.c", "-o", "testprog", "-I#{include}",
                   "-L#{lib}", "-lcfitsio"
    system "./testprog > testprog.lis"
    cmp "testprog.lis", "testprog.out"
    cmp "testprog.fit", "testprog.std"
  end
end
