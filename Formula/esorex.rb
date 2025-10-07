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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esorex-3.13.10_4"
    sha256 arm64_tahoe:   "e836a044bac9239b86bb4e4f870d3d79f9fd4445d703f705570516f0fe68dd04"
    sha256 arm64_sequoia: "9a60acbb12201c0f2f4a561cbd1d7a8c135de92125f0e5bacf48ce89e1513e90"
    sha256 arm64_sonoma:  "7702bdef5d8c3c486ef513446bd7521d946ac417ab549f4d5ede74ec3fc688df"
    sha256 sonoma:        "17732963dfedaa45d3a4c48a77f78d87c99b492f9672c21ade753a444c8a9b53"
    sha256 x86_64_linux:  "d524c68cb31c5b7f816646d98af219ee15afe71ead4ff083f8a1b73797c894a2"
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
