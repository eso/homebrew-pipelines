class EsopipeMolecfit < Formula
  desc "ESO MOLECFIT instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.4.2-2.tar.gz"
  sha256 "10217e555e2249e07f883aa5c62208fe42f406913e55a7e4fe789f4d396cafdb"
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
