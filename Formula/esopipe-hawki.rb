class EsopipeHawki < Formula
  desc "ESO HAWKI instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/hawki/hawki-kit-2.5.8-4.tar.gz"
  sha256 "603d27a16dc2c2d854efcfa4deea56afc59eb78f85ebfa369c8bb95d131fe2fb"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?hawki-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-detmon-recipes"
  depends_on "esopipe-hawki-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "hawki-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/hawki-#{version_norevision}").install Dir["hawki-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
