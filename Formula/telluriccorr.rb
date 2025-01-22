class Telluriccorr < Formula
  desc "Telluric Correction"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/telluriccorr-4.3.2.tar.gz"
  sha256 "5a4c04b90b921802bd04e988c0c7549227652b81217996c745e76ae1f8d1ab2f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/"
    regex(/href=.*?telluriccorr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/telluriccorr-4.3.2"
    sha256 arm64_sequoia: "9a520311e2f495e3c41ca7c388ce3fe302587f2b870c4556fd0a92ccd2b2fe32"
    sha256 arm64_sonoma:  "62ba0a85e9d2e2c5ad9ad7dd589db695e0300d86576c9e2bb3225fce9497e66b"
    sha256 ventura:       "5aaa4e7092705e9371618d3ea7f9644ec7044b10f5960e315c744bd76a181c15"
    sha256 x86_64_linux:  "19db5c6dd09e0a699417864d27cb46a04efd61dd7b266cd0653595cfff71ffc6"
  end

  depends_on "cpl@7.3.2"
  depends_on "molecfit-third-party"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl@7.3.2"].prefix}"
    system "make", "install"
  end

  def post_install
    ln_sf "#{Formula["molecfit-third-party"].share}/molecfit/data/hitran", "#{share}/molecfit/data/"
    ln_sf Formula["molecfit-third-party"].bin, prefix
    url = "https://ftp.eso.org/pub/dfs/pipelines/skytools/molecfit/gdas/gdas_profiles_C-70.4-24.6.tar.gz"
    filename = "#{share}/molecfit/data/profiles/gdas/gdas_profiles_C-70.4-24.6.tar.gz"
    system "curl", "-L", "-o", filename, url
  end

  test do
    system "true"
  end
end
