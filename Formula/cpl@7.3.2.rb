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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/cpl@7.3.2-7.3.2_4"
    sha256 cellar: :any,                 arm64_sequoia: "97f0e3daa7fe05a45787c606d9fd9b3da800784fd77e1f1e420533ad66427d9a"
    sha256 cellar: :any,                 arm64_sonoma:  "05edc6ab0cc92626323ce11a31370013579e249b15e952843871fce5e51fa48e"
    sha256 cellar: :any,                 ventura:       "391448fcdcb155e1ccdbfe35a637ba9d17bfa1f05b4cc3cc640ceaac4a16ee12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af8bc5af9bc753d234a19761dd1a704d670b50d56f68642a661ad4126d778f07"
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
