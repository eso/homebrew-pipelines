class EsopipeMolecfit < Formula
  desc "ESO MOLECFIT instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.4.2-3.tar.gz"
  sha256 "213dab147500b185a640a52364f9d4d602574062fa2c2f62e7141b09d46284a3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?molecfit-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-molecfit-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "molecfit-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/molecfit-#{version_norevision}").install Dir["molecfit-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
