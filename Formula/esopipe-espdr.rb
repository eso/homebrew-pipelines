class EsopipeEspdr < Formula
  desc "ESO ESPRESSO instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso/espdr-kit-3.6.0.tar.gz"
  sha256 "af577157f742790a121e02e3d0ba44330c4ab6bcc26545cc74fa4c61503ec9b7"
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
