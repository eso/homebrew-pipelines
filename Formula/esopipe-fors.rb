class EsopipeFors < Formula
  desc "ESO FORS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/fors/fors-kit-5.8.7-3.tar.gz"
  sha256 "130ae4942fe26cb92c1f7faab514fc0d3aaa21c0978d4a2bc9dcd8a30996328c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?fors-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-detmon-recipes"
  depends_on "esopipe-esotk"
  depends_on "esopipe-fors-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "fors-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/fors-#{version_norevision}").install Dir["fors-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
