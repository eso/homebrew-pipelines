class Pyesorex < Formula
  include Language::Python::Virtualenv

  desc "ESO Recipe Executor Tool for CPL/PyCPL recipes"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/pyesorex-1.0.4.tar.gz"
  sha256 "b75aab4bac3fe87f4c00093cd988efd96d548f3f4f7325fef54229d4c89a9097"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/"
    regex(/href=.*?pyesorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pyesorex-1.0.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b0014ae32bb369cc7214fab6adc4d744fce8a4f89832303488f5dc990b9cc11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d8a9920f1876e417e2a32134a84cf1dd6ee56c99aac5beb156f45085b85e56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc462231185670bc40f8865adada06c107b2a7ebef4a4dfeee2d940c8544f6aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ba878b92ab7042060769d8a2fc4ce1bf7a0eb1de94bd8fd169e59c0834b2f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d1f0c532b6fc8ca90090ac2b4989ab3da0508767b6ba2ea1a7d5317f012c7c"
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
