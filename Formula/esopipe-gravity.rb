class EsopipeGravity < Formula
  desc "ESO GRAVITY instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/gravity-kit-1.9.4.tar.gz"
  sha256 "d34c45cc0ab11f676bff30fad7456228265ffbe761aeca45ed000e2e6ec0756d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?gravity-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-gravity-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "gravity-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/gravity-#{version_norevision}").install Dir["gravity-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
