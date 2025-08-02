class EsopipeNirps < Formula
  desc "ESO NIRPS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-kit-3.3.12-1.tar.gz"
  sha256 "5552ede0a3ddb6a5dd52f4fc347d6cc78f9beae378a53afd46bf9af2b2affc14"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?nirps-kit-(\d+(?:[.-]\d+)+)\.t/i)
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
