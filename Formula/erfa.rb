class Erfa < Formula
  desc "Essential Routines for Fundamental Astronomy"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/erfa/erfa-2.0.1.tar.gz"
  sha256 "3aae5f93abcd1e9519a4a0a5d6c5c1b70f0b36ca2a15ae4589c5e594f3d8f1c0"
  license "GPL-2.0-or-later"
  revision 5

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/erfa/"
    regex(/href=.*?erfa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/erfa-2.0.1_5"
    sha256 cellar: :any, arm64_golden_gate: "561ee6dbb21bb050fc7703d6870ef8325e768ac61bb78e29c931091cbbdd0526"
    sha256 cellar: :any, arm64_tahoe:       "4063439d9b339f34fdc0805fd610624c0c347c52292be2b674748666433ede71"
    sha256 cellar: :any, arm64_sequoia:     "c17b357e7647f5ba44c939fcd1ea48e0a6cd9773586d54c99c034dfb5a298dac"
    sha256 cellar: :any, x86_64_linux:      "f45040ebf2f7f8bb40cbfac987e1fde49d2dc53fd29ed8ae831beed0435d1009"
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
