class EsopipeIiinstrument < Formula
  desc "ESO example template instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/iiinstrument-kit-0.1.14-50.tar.gz"
  sha256 "b08f398d81afce30edc968ce8b5361051d2f545c28e3ec4690c1648e3ee1f134"
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
