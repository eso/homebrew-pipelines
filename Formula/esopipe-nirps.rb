class EsopipeNirps < Formula
  desc "ESO NIRPS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-kit-3.6.0-1.tar.gz"
  sha256 "17758ebc51b8fab8f5d2de6770b6e5e3d094b25b6eea4f9b0c5737c4fd513092"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?nirps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-nirps-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "nirps-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/nirps-#{version_norevision}").install Dir["nirps-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
