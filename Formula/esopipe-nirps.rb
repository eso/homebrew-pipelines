class EsopipeNirps < Formula
  desc "ESO NIRPS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-kit-3.3.6.tar.gz"
  sha256 "2ffb561af64cfe868878524863675782c45be1970f89484964da132a58c81c4f"
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
