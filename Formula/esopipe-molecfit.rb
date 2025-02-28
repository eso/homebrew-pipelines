class EsopipeMolecfit < Formula
  desc "ESO MOLECFIT instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.3.3-5.tar.gz"
  sha256 "749b5b31c7f6c29c7904da8145fbacebe3add0ab7d6ef8cf9d3b428df20c5dd0"
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
