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
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/cfitsio@4.2.0-4.2.0"
    sha256 cellar: :any,                 arm64_sonoma: "6cc4896c2e06522f32c28948956526d9a23660ad0545ec1123b64e67d6daee9f"
    sha256 cellar: :any,                 ventura:      "de56e7ead31473d8ac02f8a498c9af50355fe6f0f39e2bdfe9388f73fd9666d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "52973416c34b3876b717809ec5bb3e9f816579916d9ecaa430e39b3eb44e0242"
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
