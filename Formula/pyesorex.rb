class Pyesorex < Formula
  include Language::Python::Virtualenv

  desc "ESO Recipe Executor Tool for CPL/PyCPL recipes"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/pyesorex-1.0.3.tar.gz"
  sha256 "8a496663448a46b8c071c521eda845b8705acf9fce9c15d46e3514a9124ecbfa"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/"
    regex(/href=.*?pyesorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pyesorex-1.0.3_1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66a6349e0e97eab83dffce0fcb8001339f644f04695a8ce55022a630fb1bd21c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d2ac6cf990dc7796fe9a3ded06de5dc70de60b75c2aa5117b5fb5a40dee418"
    sha256 cellar: :any_skip_relocation, ventura:       "aad2dd35882726df272c863689a6dc082444c9c3d71ca043b43b1d6f5947ba23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b2e03f9bfcb57b6e7f8524b91bea05f68545f4781b5ce4e7bfb648fea98134"
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
