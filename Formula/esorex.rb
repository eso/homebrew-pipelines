class Esorex < Formula
  desc "Execution Tool for European Southern Observatory pipelines"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/esorex-3.13.11.tar.gz"
  sha256 "2aca384e4c6d2010cecc9a51621ce17570d37c07239b9dca62b25aab66aebb12"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/"
    regex(/href=.*?esorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esorex-3.13.11_1"
    sha256 arm64_golden_gate: "0e1ce5f0c908110bbd73e8b2dd90d1e79ebd125ed60bf0c530e58d61d1466183"
    sha256 arm64_tahoe:       "cd50fead33e24d17cfac6a9c0eccfd9226fbcc51d4fbec0b8ae354beb0145d87"
    sha256 arm64_sequoia:     "418e307130bab7dcd67fa6db967e58040b563872c13c69663c7da7c719aa952a"
    sha256 x86_64_linux:      "5c688a92d8881cf7802b8d45df1372123566d46ebc90abb9291cf79fd35935fe"
  end

  depends_on "cpl@7.4"
  depends_on "gsl"
  depends_on "libcext"
  depends_on "libffi"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl@7.4"].prefix}",
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
