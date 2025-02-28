class EsopipeXshoo < Formula
  desc "ESO XSHOOTER instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/xshooter/xshoo-kit-3.6.8-6.tar.gz"
  sha256 "999305051d41378f1eb6816cfe8140f9ed6df5b159a5c7767e1cdaa49a441516"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?xshoo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-detmon-recipes"
  depends_on "esopipe-esotk"
  depends_on "esopipe-xshoo-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "xshoo-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/xshoo-#{version_norevision}").install Dir["xshoo-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
