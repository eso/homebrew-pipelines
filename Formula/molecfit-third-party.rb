class MolecfitThirdParty < Formula
  desc "3rd party tools for the Molecfit library"
  homepage "https://www.eso.org/sci/software/pipelines/skytools/molecfit"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/molecfit_third_party/molecfit_third_party-1.9.3.tar"
  sha256 "2786e34accf63385932bad66c39deab8c8faf4c9095a23173146a9820f4f0183"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/molecfit_third_party/"
    regex(/href=.*?molecfit_third_party[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/molecfit-third-party-1.9.3"
    sha256 cellar: :any,                 arm64_sequoia: "7c12534ab69e61ac60b8a06aee4743d505bb7c79e99f0d8b660d8d2548525b97"
    sha256 cellar: :any,                 arm64_sonoma:  "9dbbff7403171b2890ed54957fce8f47a599ad4f86e4ab87dbd06346f29d3265"
    sha256 cellar: :any,                 ventura:       "cd3771b699a79e78547c9efb9f68e3a4d3a0061804630bf04e770e6aa4bb2cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5a2b8e9e03487ba97d3b4c6f717b3debb94d802fd8a567c4926ac2ed989af85"
  end

  depends_on "gcc"

  def install
    ENV.deparallelize
    system "make", "-f", "BuildThirdParty.mk",
      "prefix=#{prefix}",
      "install"
  end

  test do
    assert_match "2460672", shell_output("echo \"2024 12 27\" | Gregorian2JD")
  end
end
