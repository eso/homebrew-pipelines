class CplAT732 < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.3.2.tar.gz"
  sha256 "a50c265a8630e61606567d153d3c70025aa958a28473a2411585b96894be7720"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/cpl@7.3.2-7.3.2_3"
    sha256 cellar: :any,                 arm64_sequoia: "0241f4fec74da515980aff40e6f3462be87ab6c0e60b8227ba122249b4ab7003"
    sha256 cellar: :any,                 arm64_sonoma:  "9ded3d18faf84b2abcb42758280d594f790f4d70b5d227023b62105121f51f8b"
    sha256 cellar: :any,                 ventura:       "acee7dea5e5551f68e0b54f9dc1d2cc71b2c68b03745d98120937030864c5863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936b838553276848f91241b0284bfb3a42667add7df5aa420066e39c61decee5"
  end

  keg_only :versioned_formula

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "wcslib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                          "--with-fftw=#{Formula["fftw"].prefix}",
                          "--with-wcslib=#{Formula["wcslib"].prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <cpl.h>
      int main(){
        cpl_init(CPL_INIT_DEFAULT);
        cpl_msg_info("hello()", "Hello, world!");
        cpl_end();
        return 0;
      }
    EOF
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lcplcore", "-lcext", "-o", "test"
    system "./test"
  end
end
