class CplAT732 < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.3.2.tar.gz"
  sha256 "a50c265a8630e61606567d153d3c70025aa958a28473a2411585b96894be7720"
  license "GPL-2.0-or-later"
  revision 5

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/cpl@7.3.2-7.3.2_5"
    sha256 cellar: :any,                 arm64_tahoe:   "6679d3b2bb3ee752f1ad943c23932abc0b9cd93545cb23eaa113f7ff216878ad"
    sha256 cellar: :any,                 arm64_sequoia: "34bb9d449021634fb88185dc5700b32a93c29ed57483b7af9bee4e32dcdf229d"
    sha256 cellar: :any,                 arm64_sonoma:  "ea323970e0b43c9d11808c2ab3f02f516c42ebf880e6fa64487ae2a7c7f0a0d4"
    sha256 cellar: :any,                 sonoma:        "a5e79fcb8d5e1a40f3fd4881e2db3513182be90b3bad562220f29fbb9d5f1e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c1b9b8b424a2068ef8015d0c8f644220d6de6687c94b99466d46d57740f3c6e"
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
