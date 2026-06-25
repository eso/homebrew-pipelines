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
