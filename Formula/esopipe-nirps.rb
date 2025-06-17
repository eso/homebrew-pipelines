class EsopipeNirps < Formula
  desc "ESO NIRPS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-kit-3.3.6-1.tar.gz"
  sha256 "148a14dfbb9f16afcd811f98f5b51f89729440f1ec114184e2dbab871d965127"
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
