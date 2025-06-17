class EsopipeGiraf < Formula
  desc "ESO GIRAFFE instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/giraffe/giraf-kit-2.18.0-2.tar.gz"
  sha256 "dd96a6e6cc738efc472043cd3cb2883c1b6673f277f18701a35b8bebabb25353"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?giraf-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-detmon-recipes"
  depends_on "esopipe-esotk"
  depends_on "esopipe-giraf-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "giraf-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/giraf-#{version_norevision}").install Dir["giraf-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
