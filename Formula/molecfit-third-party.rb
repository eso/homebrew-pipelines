class MolecfitThirdParty < Formula
  desc "3rd party tools for the Molecfit library"
  homepage "https://www.eso.org/sci/software/pipelines/skytools/molecfit"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/molecfit_third_party/molecfit_third_party-1.9.5.tar"
  sha256 "d71ff1cbf1eaec211af64b6b0fa4d8400282274b0a63ddf992ba0ab494d59161"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/molecfit_third_party/"
    regex(/href=.*?molecfit_third_party[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/molecfit-third-party-1.9.5_2"
    sha256 cellar: :any, arm64_golden_gate: "ec999cfd87782bca9d138850d81625648f6e59b54195b3b22b9ea9caad11ec27"
    sha256 cellar: :any, arm64_tahoe:       "6cce5e0531751ba51164dac402b603c5833eea2fd028049d2e8e54f0e175793c"
    sha256 cellar: :any, arm64_sequoia:     "db7176357dafe6bfa0a323f1146a97a639ea53af9f8fda0421d30c38fd211847"
    sha256 cellar: :any, x86_64_linux:      "a319eb8b4c63d75bf93ad0003c2c9802565c2f3c06f2010f806a2e4b23dc0b0a"
  end

  depends_on "gcc"

  def install
    ENV.deparallelize
    system "make", "-f", "BuildThirdParty.mk",
      "prefix=#{prefix}",
      "install"
  end

  test do
    system "true"
  end
end
