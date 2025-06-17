class EsopipeEspdr < Formula
  desc "ESO ESPRESSO instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso/espdr-kit-3.3.10-1.tar.gz"
  sha256 "3b8fae24fad1f20d058a145f17385fbca61cbc04682c142bb6a4457dee05b7cc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?espdr-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-detmon-recipes"
  depends_on "esopipe-esotk"
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
