class CfitsioAT450 < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.5.0.tar.gz"
  sha256 "e4854fc3365c1462e493aa586bfaa2f3d0bb8c20b75a524955db64c27427ce09"
  license "CFITSIO"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/cfitsio@4.5.0-4.5.0_1"
    sha256 cellar: :any,                 arm64_sequoia: "e1348961e4bc648ef4be3501f30ae4932d7797a3e219afedbc06214f8cac432e"
    sha256 cellar: :any,                 arm64_sonoma:  "fad921fd7e5d7a1584a1121691bbdfdb3d239c4143689650ff946c54e78bac36"
    sha256 cellar: :any,                 ventura:       "4c4262e443ffc4955a4c5d139f986524727225cb3b39cde8390b500e58dfe8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6fdc3702df0ec371e77dfd1a6ec85a4894ae042acf72ca2e9b7f64ccdb8cbdf"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  # Fix pkg-config file location, should be removed on next release
  patch do
    url "https://github.com/HEASARC/cfitsio/commit/d2828ae5af42056bb4fde397f3205479d01a4cf1.patch?full_index=1"
    sha256 "690d0bde53fc276f53b9a3f5d678ca1d03280fae7cfa84e7b59b87304fcdcb46"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"testprog").install Dir["testprog*", "utilities/testprog.c"]
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
