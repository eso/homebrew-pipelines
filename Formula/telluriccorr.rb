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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/telluriccorr-4.3.3_7"
    sha256 arm64_golden_gate: "2315503c1358b71b33b8a257cc744e30528de39a010e95cbe6863f102b797181"
    sha256 arm64_tahoe:       "452ddabe60257f99441b1300dd46c0eed4b273013683f8e3480d3541cdb203c3"
    sha256 arm64_sequoia:     "4b0e15e58fa6d811c6edcd085caa2635fd79fc3cce3636d7c0ec64b98c301781"
    sha256 x86_64_linux:      "3af9ce3052f48319260c273382da65c8b1eb44878202feedf69ea7ccbb7ce6b2"
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
