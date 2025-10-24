class EsopipeVisir < Formula
  desc "ESO VISIR instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/visir/visir-kit-4.6.4.tar.gz"
  sha256 "b0b99638f924c911764fe63b53077449d4d2b336f96def791af1cc96528f53f9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?visir-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-visir-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "visir-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/visir-#{version_norevision}").install Dir["visir-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
