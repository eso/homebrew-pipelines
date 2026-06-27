class EsopipeGiraf < Formula
  desc "ESO GIRAFFE instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/giraffe/giraf-kit-2.18.4-7.tar.gz"
  sha256 "1f97e3799580a47b2f422a1c385a204a0d3871bcfd6e503d609a8bc6cadf57a3"
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
