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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/erfa-2.0.1_4"
    sha256 cellar: :any,                 arm64_tahoe:   "1636d406094255692fe573a2e30b58f312020bc5e1073ec38192efd404a1d0f7"
    sha256 cellar: :any,                 arm64_sequoia: "bc6c56cec36d973deb9fe822f98dc60f0024d51095ea3d0ede1de4d7d1344696"
    sha256 cellar: :any,                 arm64_sonoma:  "d7775f19cb90590fe1f8756bcf399d6a4de21e3629e2fd8a68469628b0e58678"
    sha256 cellar: :any,                 sequoia:       "b6f8c9368e9a09ad0c422a453b70388832af5ff034c632b28ad9ce9305103e57"
    sha256 cellar: :any,                 sonoma:        "6f7b95beb3e1df0d8476dcb3e883c37a8c0e871d6537b973dbd49690f6b77722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f01f4f228ead4e6f2707e0089101a27079636b9942d2615677d71e2d34104117"
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
