class Telluriccorr < Formula
  desc "Telluric Correction"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/telluriccorr-4.3.3.tar.gz"
  sha256 "dffc4ef40d7d279f11ab402fc711724b3fd52412331b0baffb6ccf100d3b39d3"
  license "GPL-2.0-or-later"
  revision 5

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/"
    regex(/href=.*?telluriccorr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/telluriccorr-4.3.3_5"
    sha256 arm64_tahoe:   "157c72f6bdbd660bbf6eedef80d54359ff3b6a6c297d4a8913c0042baf1df5c8"
    sha256 arm64_sequoia: "777c419bc2bb6587e4f8dd08a915bf3f6e0656fc67a91d781bd7484d4094efef"
    sha256 arm64_sonoma:  "a0d56a3cbb4c933fa287260a65d4979a2931df850e59bd278e367a2b159bbad9"
    sha256 sonoma:        "afdb04c2affc347fc1c68de9447c97a16c33a57c91aab2dc912ce62545eb7fe5"
    sha256 x86_64_linux:  "dc8cd4e5326084de8f2d25b6c097c9ea2d5bef4d07918f404d71985427df1da9"
  end

  depends_on "cpl@7.4"
  depends_on "molecfit-third-party"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl@7.4"].prefix}"
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
