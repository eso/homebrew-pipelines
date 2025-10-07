class MolecfitThirdParty < Formula
  desc "3rd party tools for the Molecfit library"
  homepage "https://www.eso.org/sci/software/pipelines/skytools/molecfit"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/molecfit_third_party/molecfit_third_party-1.9.5.tar"
  sha256 "d71ff1cbf1eaec211af64b6b0fa4d8400282274b0a63ddf992ba0ab494d59161"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/molecfit_third_party/"
    regex(/href=.*?molecfit_third_party[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/molecfit-third-party-1.9.5"
    sha256 cellar: :any,                 arm64_sequoia: "fc428edf1768fb9f4bd7f80a3a9f03dfb08d5cb43c880c7d59ae054a8ef7269d"
    sha256 cellar: :any,                 arm64_sonoma:  "07a6287eeccbf7f6b8e8bd52cd77393d101bd1da93f52e814c0ac4c1e632fd92"
    sha256 cellar: :any,                 ventura:       "10c75f6552fc6effaff5e2ad17a0a5fcfa07a9a5510a81934d4e54c6659eeb6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f46aacdb106ed0c595fa81e142933e4d3f7f2030c71518d039729bfdaad1cdb"
  end

  depends_on "gcc"

  def install
    ENV.deparallelize
    system "make", "-f", "BuildThirdParty.mk",
      "prefix=#{prefix}",
      "install"
  end
end
