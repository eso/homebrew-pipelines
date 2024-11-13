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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pycpl-1.0.0_3"
    sha256 cellar: :any,                 arm64_sequoia: "789eaa91548f50c996032c140b4cc1ac18f5b0c2035926b9e176506f87340725"
    sha256 cellar: :any,                 arm64_sonoma:  "26ff606b0adb384cde6cd8fe8adcfa25d5e0bab226958d2fa48b30a5920b8faf"
    sha256 cellar: :any,                 ventura:       "3c24538e5f8e699df682ba328ceae6c5d5633631df8eb47b3de636c8edbcc5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e30c247efd3a94a1ff810b58c8eba8d8029e041d1b2d0a94c84873973fa68623"
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
