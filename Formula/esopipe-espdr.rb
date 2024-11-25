class EsopipeEspdr < Formula
  desc "ESO ESPRESSO instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso/espdr-kit-3.3.0.tar.gz"
  sha256 "4ec59051a56b895c6d2be921eff30c7532ed7d05ab9fb217cd88abf9941387c4"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?espdr-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-espdr-3.3.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a1d0daa74b143da4efd2b3fed27a02683d0d8f4a45dd4e2a1a3faac308cc9bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "664f7e2b77418a083eb98d661a0a449aa825fd52c6be3835c847d32286c5ccd2"
    sha256 cellar: :any_skip_relocation, ventura:       "dfbb0aa434fdc9cd8b487cf57b914a7fe6929ca99c04cb6178905e6d67d4b636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "608232a24b21a2dd0ac9a206ca813196f3f35c3c494a5681b45452433cbc104c"
  end

  depends_on "esopipe-espdr-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "espdr-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/espdr-#{version_norevision}").install Dir["espdr-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
