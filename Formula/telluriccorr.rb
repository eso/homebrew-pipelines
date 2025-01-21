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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/telluriccorr-4.3.1_2"
    sha256 arm64_sequoia: "df7733a9c20c67551ed5f6dbd288d91d516fe63f79bba615e5190f4073c09b07"
    sha256 arm64_sonoma:  "7b94d22a0d650d7a016e9c2161b409008e7f88d3f039e93d16200ba2ca7a22e9"
    sha256 ventura:       "5b6a7c445772636807fc2f09df4f35292826d65594711f11a72ddccb2f36ed4f"
    sha256 x86_64_linux:  "dc5f1b24dfaf16ff7c4a1b32694ea2fa4c673cfbdf3b9fa7cc8112a996253847"
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
