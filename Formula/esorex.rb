class Esorex < Formula
  desc "Execution Tool for European Southern Observatory pipelines"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/esorex-3.13.11.tar.gz"
  sha256 "2aca384e4c6d2010cecc9a51621ce17570d37c07239b9dca62b25aab66aebb12"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/"
    regex(/href=.*?esorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esorex-3.13.11"
    sha256 arm64_tahoe:   "cee7051ceab9456a0c320b563699d44f9f2335e3a60b7f9de729a7140b48a057"
    sha256 arm64_sequoia: "2a2e566d955861b86789db07a1aa9e122008c9cfce522e5fc0a4152adad584e6"
    sha256 arm64_sonoma:  "bcb9458d44eec6f5b7016aa2a6d53fa4cf98b36424e61ebc7f053642f9102cb9"
    sha256 sonoma:        "ab16b4eb1c397c25f3e978bc88aa702c7c61d46f151f4ac81bd73d46ff6cbadc"
    sha256 x86_64_linux:  "69d3700a5b6fcfefedb7656bf8611b99b33eeb28665cac604374f75adcf9c578"
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
