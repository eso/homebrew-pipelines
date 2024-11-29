class EsopipeHarps < Formula
  desc "ESO HARPS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/harps/harps-kit-3.3.0.tar.gz"
  sha256 "d42971a953651ff4ea1a043b8203957944122feb4cfee2ff42a7b6d3a1251098"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?harps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-harps-3.3.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40d746ba6a33533c751712a45a258d9e39323e5e84121bcdd7fb06dee8f496ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c69fd8181e948e1371ccf3bfda668b41b7ccdb4135147b2b2af25893670cc91"
    sha256 cellar: :any_skip_relocation, ventura:       "79a3310d2cfd91e49b46f2d2566edd50a79946cab60e17e92baf7097ca8baf1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abdb5bd68999af29f0afb9e4a647618a55eec30e707a0330ef2b478ea89fb4e8"
  end

  depends_on "esopipe-harps-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "harps-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/harps-#{version_norevision}").install Dir["harps-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
