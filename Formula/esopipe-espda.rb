class EsopipeEspda < Formula
  desc "ESO ESPRESSO-DAS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso-das/espda-kit-1.3.8.tar.gz"
  sha256 "d100d9c4318fcfd853f445413ee5a73ad8ca5f41f359ea016afae3758e7e33d6"
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
