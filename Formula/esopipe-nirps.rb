class EsopipeNirps < Formula
  desc "ESO NIRPS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-kit-3.3.0.tar.gz"
  sha256 "efb541607aadfb22cbba8cfc5c581c8c4a48ae6ea8b8b92080eb36b615b80e51"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?nirps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-nirps-3.3.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "250c88b2edcbe8ae88f0a1a7b9318fbcb989019e97a9fcad806b258745888538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f84e16111f9b4e3cb462b9b17ad4077c8b3e46066bdb61950fed797686726d6"
    sha256 cellar: :any_skip_relocation, ventura:       "fc8ff4132ce639d482eaf1edbc8e89f2f4a8aa3c7ce9ac4e110cdba2e229d646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ae61ed030323c9b24cc3abbddec94c9c7d8a19851837f82183da5fdd7ca58e1"
  end

  depends_on "esopipe-nirps-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "nirps-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/nirps-#{version_norevision}").install Dir["nirps-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
