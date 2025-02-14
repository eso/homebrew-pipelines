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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esorex-3.13.9_2"
    sha256 arm64_sequoia: "ab4afae89a5ec263f686a3ef3bac64a202ab393f76fd43420dc36492f5f1ceb4"
    sha256 arm64_sonoma:  "50b1f55c30a78ef6362ead332577a11f372b86fbff30febf20117ae8c64fd468"
    sha256 ventura:       "63055b75f87eadb9f2f64fa18a52ebe804cf954078929605ca06b83fb504ffd2"
    sha256 x86_64_linux:  "60fdf7868fcac1e4f3fb84019bb06119a13945121e4e17c83e1fe9d7c922987e"
  end

  depends_on "cpl@7.3.2"
  depends_on "gsl"
  depends_on "libffi"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
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
