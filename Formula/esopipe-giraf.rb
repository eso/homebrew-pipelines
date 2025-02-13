class EsopipeGiraf < Formula
  desc "ESO GIRAFFE instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/giraffe/giraf-kit-2.16.12.tar.gz"
  sha256 "6920f5a672fd2f8bb312180e922707707e747661e6767897bb229afa4da89a04"
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
