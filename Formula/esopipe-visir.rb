class EsopipeVisir < Formula
  desc "ESO VISIR instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/visir/visir-kit-4.4.5.tar.gz"
  sha256 "8833896bfc1e85e60a3a7d24c015d2ec5ca81807e908a0ca5a70970347d1aaa0"
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
