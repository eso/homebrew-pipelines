class Pyesorex < Formula
  include Language::Python::Virtualenv

  desc "ESO Recipe Executor Tool for CPL/PyCPL recipes"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/pyesorex-1.0.0.tar.gz"
  sha256 "248634872bf094bf20063ca1662e0c62b9a4cfd0119a6447de176ea7fa63a930"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/"
    regex(/href=.*?pyesorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/pyesorex-1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9089ebced8b22f7a300861542931f2bf8fa6f687866bf5b480e36a46697372b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f010083f44ac19e675ec51f09c29acaf58537a8eaa67c0604c404e16d59c161"
    sha256 cellar: :any_skip_relocation, ventura:       "b1ee718c48832466a5d7a5e699d7dcd0ac62143988e105268f06d9a13547e847"
    sha256 cellar: :any_skip_relocation, monterey:      "1d36d506259d4a0af16692f3d5bf312b9fc6cb0f82046cdbbd149a8f0cc1f160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d163d8ff437d6f49e17a36478c5ad8d708e42ab66b9b160a236efc30fbdafcc5"
  end

  depends_on "pycpl"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "true"
  end
end
