class EsopipeEspda < Formula
  desc "ESO ESPRESSO-DAS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso-das/espda-kit-1.4.0-3.tar.gz"
  sha256 "7b4a07376cc9c4660fac012bdfea1b04915d8873608a9a7180b5a54dadaac9c5"
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
