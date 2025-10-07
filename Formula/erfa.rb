class Erfa < Formula
  desc "Essential Routines for Fundamental Astronomy"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/erfa/erfa-2.0.1.tar.gz"
  sha256 "3aae5f93abcd1e9519a4a0a5d6c5c1b70f0b36ca2a15ae4589c5e594f3d8f1c0"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/erfa/"
    regex(/href=.*?erfa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/erfa-2.0.1_3"
    sha256 cellar: :any,                 arm64_sequoia: "452c76d8e7027a60117c6e27eb65f2db9189e861edded4dd9081d806d039ebc9"
    sha256 cellar: :any,                 arm64_sonoma:  "4a3769f10590bde883dde6fd61f600bfb4b0e1f511491c0e889bbd191fc02ce4"
    sha256 cellar: :any,                 ventura:       "49cb84aa66c7b4ed3fad4d34990663049f840f6bec8e20bcbee29fa730065598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac0398cb1fd7505e5afc2bf80b5e185fcfac583557a44c7b97ebabe162cf57c"
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
