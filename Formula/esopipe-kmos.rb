class EsopipeKmos < Formula
  desc "ESO KMOS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/kmos/kmos-kit-4.5.3-3.tar.gz"
  sha256 "c3bc8cf3cddee77f2755c4241b730aa736da07aff20629df2137a0b3f575bd77"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?kmos-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-kmos-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "kmos-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/kmos-#{version_norevision}").install Dir["kmos-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
