class Erfa < Formula
  desc "Essential Routines for Fundamental Astronomy"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/erfa/erfa-2.0.1.tar.gz"
  sha256 "3aae5f93abcd1e9519a4a0a5d6c5c1b70f0b36ca2a15ae4589c5e594f3d8f1c0"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/erfa/"
    regex(/href=.*?erfa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/erfa-2.0.1_2"
    sha256 cellar: :any,                 arm64_sonoma: "a286e513d8c87a0ba57de9343e262d6bf574a6ab6d75e7c098fffa0d0f0bc5a3"
    sha256 cellar: :any,                 ventura:      "918d87ef2a98dc79291fe2a6d15824fe5fedafb55d0d7e5b00fd314910dd3ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "26e3678243e35a038ab7b4efb412346206a6cb55d695ad78d8172726ca00da0c"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <erfa.h>
      int main()
      {
        double a[3] = {1, 2, 3};
        double b[3];
        eraCp(a, b);
        return 0;
      }
    EOF
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lerfa", "-o", "test"
    system "./test"
  end
end
