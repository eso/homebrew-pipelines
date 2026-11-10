class EsopipeEspda < Formula
  desc "ESO ESPRESSO-DAS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso-das/espda-kit-1.4.0-10.tar.gz"
  sha256 "50daea2d68a7cf2b5fff83b572b3138dce286f1940e48ff55062b25c3c561f0c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?espda-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-espda-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "espda-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/espda-#{version_norevision}").install Dir["espda-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
