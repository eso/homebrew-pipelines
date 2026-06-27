class EsopipeMolecfit < Formula
  desc "ESO MOLECFIT instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.4.4-10.tar.gz"
  sha256 "ce539c12905ac7f8cd5537a9a56901843813b2055d4291c703f3140c5957092b"
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
