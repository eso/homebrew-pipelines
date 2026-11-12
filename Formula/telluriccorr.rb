class Telluriccorr < Formula
  desc "Telluric Correction"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/telluriccorr-4.3.3.tar.gz"
  sha256 "dffc4ef40d7d279f11ab402fc711724b3fd52412331b0baffb6ccf100d3b39d3"
  license "GPL-2.0-or-later"
  revision 7

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/"
    regex(/href=.*?telluriccorr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/telluriccorr-4.3.3_6"
    sha256 arm64_tahoe:   "b1af190913f7022b02a7ed473d42534fb45ec599434b3e443c6353102427cae6"
    sha256 arm64_sequoia: "a79bea75103865881dd54282e5d7a98b2d19fb21c0aec9727c4250cdac668248"
    sha256 x86_64_linux:  "0c5b1d1c4e01bcc5cf5f4d2f621bd108dc069ca5e0f6d8f3af3ca61ae2c80dbc"
  end

  depends_on "cpl@7.4"
  depends_on "molecfit-third-party"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl@7.4"].prefix}"
    system "make", "install"

    mkdir_p share/"molecfit/data"
    ln_sf Formula["molecfit-third-party"].share/"molecfit/data/hitran", share/"molecfit/data"
    ln_sf Formula["molecfit-third-party"].bin, prefix
  end

  test do
    system "true"
  end
end
