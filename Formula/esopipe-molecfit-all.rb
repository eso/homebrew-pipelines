class EsopipeMolecfitAll < Formula
  desc "ESO MOLECFIT instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-demo-reflex-1.5.tar.gz"
  sha256 "eec222de7d2de2ac554b03d4cfd21991e16ee60cdf4eed658c05b10ef46d4073"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?molecfit-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-molecfit"

  def install
    (prefix/"share/esopipes/datademo/molecfit").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-molecfit-all"
  end

  test do
    system "true"
  end
end
