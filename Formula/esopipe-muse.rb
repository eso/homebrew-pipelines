class EsopipeMuse < Formula
  desc "ESO MUSE instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/muse/muse-kit-2.11.6.tar.gz"
  sha256 "3d69465b9a6fa8499bd4f8f1035328c21b5d35c2a13f090279d307b98c32a730"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?muse-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-muse-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "muse-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/muse-#{version_norevision}").install Dir["muse-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
