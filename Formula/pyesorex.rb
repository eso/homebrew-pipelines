class Pyesorex < Formula
  include Language::Python::Virtualenv

  desc "ESO Recipe Executor Tool for CPL/PyCPL recipes"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/pyesorex-1.0.1.tar.gz"
  sha256 "13b84af0e696fd11c624b84cba5adf87409a74a593716fc7a3a57be0ce3f1562"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/"
    regex(/href=.*?pyesorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pyesorex-1.0.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1365fd264eb14ff737258600fbcefefcd1dd005900cf790829b433af34e4c5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40b03f19f87718122a460ed97e832fcfac210204d8f051e4b4e9f6ff6db85d24"
    sha256 cellar: :any_skip_relocation, ventura:       "cb733e97bdc021c2588573bcf83fdcc1dfa05432b4130e22d7af56846e3347c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3883b6f9ec737b8103dd5057ad6ef8e28b2c8014d312b638296e94f7c8985c80"
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
