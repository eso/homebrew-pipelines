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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/molecfit-third-party-1.9.5_1"
    sha256 cellar: :any,                 arm64_tahoe:   "fd735b8a88d64cb1ca6f052ce4cc7904bad088ad416206f3d1c04b9a9601da02"
    sha256 cellar: :any,                 arm64_sequoia: "5e9c9a4172d8930737549c643247815d89c8134d913409dd4f08876c743c6854"
    sha256 cellar: :any,                 arm64_sonoma:  "860716d238a2366f5a769684c5f7a49c4e35e2972ca7735ad0e768325c21f0c0"
    sha256 cellar: :any,                 sequoia:       "bafbfb6193ebab1f4c0ccb69da9f2a75a9140e1713d1ac13d99fd5c00e88ea85"
    sha256 cellar: :any,                 sonoma:        "b3469dc1d0d7690ff51874185c2cf87e7d75e09ef37bedd7e0c5b1261a91b126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f18315216ded6eed919fad613c465b2f9f5602ad6c3ba406d9852e2e3876c75"
  end

  depends_on "gcc"

  def install
    ENV.deparallelize
    system "make", "-f", "BuildThirdParty.mk",
      "prefix=#{prefix}",
      "install"
  end
end
