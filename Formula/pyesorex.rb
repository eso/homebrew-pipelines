class Pyesorex < Formula
  include Language::Python::Virtualenv

  desc "ESO Recipe Executor Tool for CPL/PyCPL recipes"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/pyesorex-1.0.3.tar.gz"
  sha256 "8a496663448a46b8c071c521eda845b8705acf9fce9c15d46e3514a9124ecbfa"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyesorex/"
    regex(/href=.*?pyesorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pyesorex-1.0.3_2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10ebd5a3e7335b002f0e539a3a89cae64f12225b0f6f9a27ac693ec135a14457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3997197187902420855fa5f2eb72538df4e28eae508d3a26803c48ece43a7f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88f20c1e1e0fcf07065e8888f11d13581f639d390c96b78ccee32c0615d9872c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d308f5a51ffbf009251594bedebfb9a89493ecea04c42c5bc884c5e52cb34f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad5ed7fee147e042e295edb1e16277092c3fbcd70baa9063673ed73fdbc422db"
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
