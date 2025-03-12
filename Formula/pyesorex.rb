class Pyesorex < Formula
  include Language::Python::Virtualenv

  desc "ESO Recipe Executor Tool for CPL/PyCPL recipes"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/pyesorex-1.0.2.tar.gz"
  sha256 "a132d47dbe12351c557b899e5b2b07b12271d44bb5e2afcb2e95632e9f171264"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/"
    regex(/href=.*?pyesorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pyesorex-1.0.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff04ac90fe3b6a25d544ac17daf2a99bed40cbac11d34377594be38fac4914a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f3b2fea2f849c12c173aa3b7020b050177a8f82799fc852e34cee78b78a2fdd"
    sha256 cellar: :any_skip_relocation, ventura:       "5a942b5d06fa2b38aa19b919123b24e61efb84251ba0a82be62ab0053979cf93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc07c962090b624c4871a65a8dd9cb67f20488112450f6cf08d00c63f08df444"
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
