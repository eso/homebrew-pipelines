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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pyesorex-1.0.1_1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b11a9defc93a5fb5bb5112f7512eeb7421431411a05ae48d722d2b377413c3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56ff5ee6d094116d59641e992eac7c041b86c2e1a0a0b3c28f15cdd8b2a28bd2"
    sha256 cellar: :any_skip_relocation, ventura:       "68603c7043a47348e7c1d84b74ac65da463c5c40b8fe71f9a17cccc952197457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c860405ddf420d328e1db15bda39da3de0006dec1db7845b449920c1ac39465c"
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
