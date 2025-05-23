class Pyesorex < Formula
  include Language::Python::Virtualenv

  desc "ESO Recipe Executor Tool for CPL/PyCPL recipes"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/pyesorex-1.0.3.tar.gz"
  sha256 "8a496663448a46b8c071c521eda845b8705acf9fce9c15d46e3514a9124ecbfa"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/"
    regex(/href=.*?pyesorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pyesorex-1.0.3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0130d846428fede5bdb287616232c7d369efc9d6d4225e93eb727e063e2625e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4b27196923f0b3430d5af1fc8c42b212b6cb26b2c58cc2b136b4b50c38994aa"
    sha256 cellar: :any_skip_relocation, ventura:       "fd8a08dd894675dbb0ac4ca3b8d716c79e827d848a5323751d4d291535a249fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77b6be598c2b07931088f10cbcca4efb79fda277c0c151847c617f5b3b8ce290"
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
