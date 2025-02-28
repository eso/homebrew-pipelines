class EsopipeHarps < Formula
  desc "ESO HARPS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/harps/harps-kit-3.3.0-4.tar.gz"
  sha256 "38f004979399c4c07ded7a56fe2fabf2edf105a1994402af50dbacdf8626d78d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?harps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-harps-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "harps-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/harps-#{version_norevision}").install Dir["harps-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
