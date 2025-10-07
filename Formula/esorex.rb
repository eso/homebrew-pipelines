class Esorex < Formula
  desc "Execution Tool for European Southern Observatory pipelines"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/esorex-3.13.10.tar.gz"
  sha256 "a989f9c6dbd6bbb6a9c7c678da8a3b7ad7a8c7e29c644b97c371579b45957dd6"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/"
    regex(/href=.*?esorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esorex-3.13.10_3"
    sha256 arm64_sequoia: "4e3e5ca7b90441b4739658603c28850f0ca5cedad7ea779499e0ea128880690b"
    sha256 arm64_sonoma:  "48195e368aba664236d19a4a02ddd62cfcf83575dacebe5b42cf91873095145a"
    sha256 ventura:       "668360b7b3b28d06fad1b1407268614c481682f9830c3282ce05b56ea60b4559"
    sha256 x86_64_linux:  "4e2d17ab7f8cfc2479680e5d9e534d5ef0d85fe8682948edbd164e5cfcf36de7"
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
