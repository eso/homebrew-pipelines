class Esorex < Formula
  desc "Execution Tool for European Southern Observatory pipelines"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/esorex-3.13.9.tar.gz"
  sha256 "609c484c7ac2c3b30cf6dbead25430b05c850f80aa140be3c85ffd104305ebc0"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/"
    regex(/href=.*?esorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esorex-3.13.9_1"
    sha256 arm64_sonoma: "a39a3836fe52dc524d688f1767df1f78bbb07ad3b6d5c218c6ec4013324efa14"
    sha256 ventura:      "c63b6e413e0b1e21ec7b5ee189a9077a5130222191032483f91625f7376ee977"
    sha256 x86_64_linux: "3f67e7fa2d3db05da37df38a1dc14f64bea202867aefd7f86ccd7fe7b1c92b2f"
  end

  depends_on "cpl@7.3.2"
  depends_on "gsl@2.6"
  depends_on "libffi"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                          "--with-gsl=#{Formula["gsl@2.6"].prefix}",
                          "--with-libffi=#{Formula["libffi"].prefix}",
                          "--with-included-ltdl"
    system "make", "install"
    inreplace prefix/"etc/esorex.rc", prefix/"lib/esopipes-plugins", HOMEBREW_PREFIX/"lib/esopipes-plugins"
  end

  test do
    assert_match "ESO Recipe Execution Tool, version #{version}", shell_output("#{bin}/esorex --version")
  end
end
