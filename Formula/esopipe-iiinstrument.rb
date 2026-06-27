class EsopipeIiinstrument < Formula
  desc "ESO example template instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/iiinstrument-kit-0.1.16-6.tar.gz"
  sha256 "57d62106ad3f26582dce3d6c5467b76a8a75835429fd074786a9cf4dbc7b1806"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/"
    regex(/href=.*?iiinstrument-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-iiinstrument-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "iiinstrument-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/iiinstrument-#{version_norevision}").install Dir["iiinstrument-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
