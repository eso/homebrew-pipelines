class Telluriccorr < Formula
  desc "Telluric Correction"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/telluriccorr-4.3.3.tar.gz"
  sha256 "dffc4ef40d7d279f11ab402fc711724b3fd52412331b0baffb6ccf100d3b39d3"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/"
    regex(/href=.*?telluriccorr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/telluriccorr-4.3.3_4"
    sha256 arm64_tahoe:   "c4187966c93ec5fc0e0c1b775ec743366d499df1ab7c5dee6abb93fb028cb724"
    sha256 arm64_sequoia: "062be9738d52947a9e0602bb0cd04fee00027fdc74bd3f8004ce2de75d6ff14a"
    sha256 arm64_sonoma:  "8b2c3d9a522968df0d2c240940c1a25d87a27bef5b77d1999c8de279eb6c4a14"
    sha256 sonoma:        "e98109d78c4cc4e925ddf34f8b754658761d4235d8cf152eef995e0609fb768e"
    sha256 x86_64_linux:  "a19e4d279005cc7777bece392c4774a22e8c5b8cd759c0dff97d08c9ce2c71fd"
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
