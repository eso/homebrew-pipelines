class EsopipeIiinstrument < Formula
  desc "ESO example template instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/iiinstrument-kit-0.1.16.tar.gz"
  sha256 "58ae45bc8b73234f3097400154cd20c16e1235494c5092c6063ab92d0faee996"
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
