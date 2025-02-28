class EsopipeEris < Formula
  desc "ESO ERIS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/eris/eris-kit-1.7.0-6.tar.gz"
  sha256 "1950e6208671565f73136770088f09798d234d4a1d405a2a752bf06b976aab3d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?eris-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-eris-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "eris-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/eris-#{version_norevision}").install Dir["eris-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
