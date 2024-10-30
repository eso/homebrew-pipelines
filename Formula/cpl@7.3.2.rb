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
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/cpl@7.3.2-7.3.2_2"
    sha256 cellar: :any,                 arm64_sonoma: "2557d84e65750eda026b1cfb9008236f8e71861093d61b9c057cdf64cd8c75e0"
    sha256 cellar: :any,                 ventura:      "ec3b6ff619b070a10163a826f93c5550149579f24d8f89f248029e77ce2b782e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8af835d9c97a903b06f868bc5abc1c7d619261f6bcd3ddece021f1ded2696ae3"
  end

  keg_only :versioned_formula

  depends_on "cfitsio@4.2.0"
  depends_on "fftw@3.3.9"
  depends_on "wcslib@7.12"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cfitsio=#{Formula["cfitsio@4.2.0"].prefix}",
                          "--with-fftw=#{Formula["fftw@3.3.9"].prefix}",
                          "--with-wcslib=#{Formula["wcslib@7.12"].prefix}"
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
