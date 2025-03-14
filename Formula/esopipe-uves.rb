class EsopipeUves < Formula
  desc "ESO UVES instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/uves/uves-kit-6.5.2.tar.gz"
  sha256 "54c4dc61f257d0049ffb016b64c50900795315ff8082d78f1915e377a352c8ad"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?uves-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-detmon-recipes"
  depends_on "esopipe-esotk"
  depends_on "esopipe-uves-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "uves-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/uves-#{version_norevision}").install Dir["uves-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
