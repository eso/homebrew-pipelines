class Pycpl < Formula
  desc "Python Language Bindings for CPL"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/pycpl-1.0.0.tar.gz"
  sha256 "aa9ee7e26d88a751494b9484542ea2285acbed3ff026821ff6bc54540aba3def"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/"
    regex(/href=.*?pycpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/pycpl-1.0.0_1"
    sha256 cellar: :any,                 arm64_sonoma: "915c0f5353475f0e9929600af26bf6310c227d2596e2dc757203b067ac26d529"
    sha256 cellar: :any,                 ventura:      "2b23fa35b5ebc44e24e82d3735f9c4445fb22ca52788fc195e122c0621237bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a7020886c8ba61959f71edd41075233158f4762a1f7ecd9df5922365842201a8"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "cpl@7.3.2"
  depends_on "python@3.11"

  def install
    system "python", "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    system "true"
  end
end
