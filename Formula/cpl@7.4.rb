class CplAT74 < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.4.tar.gz"
  sha256 "63171467e9deab880842f3e5589c02698c4637cf75106c4aa39affd84ecd8bd4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/cpl@7.4-7.4"
    sha256 cellar: :any, arm64_tahoe:   "d6e512f587c5c1e526624b834f9db5f69177cda4b225a696ebd09a8e351830c9"
    sha256 cellar: :any, arm64_sequoia: "16c2bc4d0a769cccc663b278baa409f72900c536204430f39753e367233b5b6b"
    sha256 cellar: :any, arm64_sonoma:  "2041dc28eb578e50b2036637ab989b17664de36d8e078c27a9c1e012717c1727"
    sha256 cellar: :any, sonoma:        "bf27cba092cfe2264ab9ce0b32e84fb5824ec6c9059cc9eaa4c9047a826e056c"
    sha256 cellar: :any, x86_64_linux:  "2d27c7a3a08366ae578ec886267090036b0a1a2d8454fe634673141e850767f6"
  end

  keg_only :versioned_formula

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "libcext"
  depends_on "wcslib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                          "--with-fftw=#{Formula["fftw"].prefix}",
                          "--with-libcext=#{Formula["libcext"].prefix}",
                          "--with-wcslib=#{Formula["wcslib"].prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <cpl.h>
      int main(){
        cpl_init(CPL_INIT_DEFAULT);
        cpl_msg_info("hello()", "Hello, world!");
        cpl_end();
        return 0;
      }
    C
    libcext = Formula["libcext"]
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcplcore",
                             "-I#{libcext.include}", "-L#{libcext.lib}", "-lcext", "-o", "test"
    system "./test"
  end
end
