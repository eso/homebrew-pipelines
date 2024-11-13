class Pycpl < Formula
  desc "Python Language Bindings for CPL"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/pycpl-1.0.0.tar.gz"
  sha256 "aa9ee7e26d88a751494b9484542ea2285acbed3ff026821ff6bc54540aba3def"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/"
    regex(/href=.*?pycpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pycpl-1.0.0_2"
    sha256 cellar: :any,                 arm64_sequoia: "65eaecc51b17d4d3f17515bf1642da76ffcad28ab9b731a9cb602994b8b3dbfe"
    sha256 cellar: :any,                 arm64_sonoma:  "f3263d915e2f1cffbc089b55eedf76e772ea2c6a0bad213037cf5b2c0d07b84d"
    sha256 cellar: :any,                 ventura:       "96e8d70de586737eb2d098b53ac3fd4ec6edc16aef5b8721912b421c5b326f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d51cfa0855909b8963741115353a67b84447c8e4e6ca281e4a8f4f73f3e181c7"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "cpl@7.3.2"
  depends_on "python@3.11"

  def install
    ENV["PYCPL_RECIPE_DIR"] = HOMEBREW_PREFIX/"lib/esopipes-plugins"
    system "python", "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    system "true"
  end
end
