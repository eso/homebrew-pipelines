class Telluriccorr < Formula
  desc "Telluric Correction"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/telluriccorr-4.3.2.tar.gz"
  sha256 "5a4c04b90b921802bd04e988c0c7549227652b81217996c745e76ae1f8d1ab2f"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/"
    regex(/href=.*?telluriccorr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/telluriccorr-4.3.2_1"
    sha256 arm64_sequoia: "6aede7f47b3b33cbcf321c69e37d7b1978e97ec5bf17b0bbe96d85c4982588e3"
    sha256 arm64_sonoma:  "97a37152357177eca466279dd1c61b568e941cc25dccab8979c42e065d8acd8d"
    sha256 ventura:       "ff639fc3856ec57e69d484f5e514057704b3d3853d828e9d63da1cc1712c9c04"
    sha256 x86_64_linux:  "bc237c1cadd0a0ab2345e11781a8bbbeaa45dce00da615676685a442fb0b3b87"
  end

  depends_on "cpl"
  depends_on "molecfit-third-party"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl"].prefix}"
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
