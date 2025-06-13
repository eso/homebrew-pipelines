class Esorex < Formula
  desc "Execution Tool for European Southern Observatory pipelines"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/esorex-3.13.10.tar.gz"
  sha256 "a989f9c6dbd6bbb6a9c7c678da8a3b7ad7a8c7e29c644b97c371579b45957dd6"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/"
    regex(/href=.*?esorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esorex-3.13.10_1"
    sha256 arm64_sequoia: "84c7b032b3e227dab81bc652383c57fd57eef4e0c5a8e38ffcdb0263fbfd526c"
    sha256 arm64_sonoma:  "e9b5a2693b428c1136f670eb470e94f220b0dab3e53cba3816de34b7e9736758"
    sha256 ventura:       "2f5d9f8f216a49e92f79b2c3325d41f82aa2a96586e06b1ccbf5199f3cb1fb5f"
    sha256 x86_64_linux:  "a87baae0b14485200b1a910e1cb6ff245edcb2de8627d57442ae364051c34879"
  end

  depends_on "cpl"
  depends_on "gsl"
  depends_on "libffi"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl"].prefix}",
                          "--with-gsl=#{Formula["gsl"].prefix}",
                          "--with-libffi=#{Formula["libffi"].prefix}",
                          "--with-included-ltdl"
    system "make", "install"
    inreplace prefix/"etc/esorex.rc", prefix/"lib/esopipes-plugins", HOMEBREW_PREFIX/"lib/esopipes-plugins"
  end

  test do
    assert_match "ESO Recipe Execution Tool, version #{version}", shell_output("#{bin}/esorex --version")
  end
end
