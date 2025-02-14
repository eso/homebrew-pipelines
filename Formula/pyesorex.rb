class Pyesorex < Formula
  include Language::Python::Virtualenv

  desc "ESO Recipe Executor Tool for CPL/PyCPL recipes"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/pyesorex-1.0.1.tar.gz"
  sha256 "13b84af0e696fd11c624b84cba5adf87409a74a593716fc7a3a57be0ce3f1562"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/"
    regex(/href=.*?pyesorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pyesorex-1.0.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "200f482ff9b4f990a5cda15d9e03c9de6f41285e9b21d6ad8d02d0f51861a9c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f2ab4a694079a02a7df689f7db8894130fcdd6bd16a8612f940f9f2f7f3cc11"
    sha256 cellar: :any_skip_relocation, ventura:       "253d9895a33bda0d7644c20243efd28a784c1a28a563e1724a7ef3e54a693b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8afded2c9bead21967e8a01962c53cd435b03de202f074941564a11c2b806a39"
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
