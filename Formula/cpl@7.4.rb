class CplAT74 < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.4.tar.gz"
  sha256 "63171467e9deab880842f3e5589c02698c4637cf75106c4aa39affd84ecd8bd4"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/cpl@7.4-7.4_1"
    sha256 cellar: :any, arm64_golden_gate: "240d72db804e24ad7c7987bfb577a372db8a21efcd7193e107dbdc3bcbb98061"
    sha256 cellar: :any, arm64_tahoe:       "a9553c53fe1ef934d7ae6f56b67b3bd2852234355a68528e670daf7b1cc86a27"
    sha256 cellar: :any, arm64_sequoia:     "4f5088c9edc546db7fd60aa903e3fe75af273cb2a90cb4102b68f5bcea3c10c2"
    sha256 cellar: :any, x86_64_linux:      "75f844089c9cb5db9b49f886e62064e7b78d1f59ba9fa36847f996672b169ebb"
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
