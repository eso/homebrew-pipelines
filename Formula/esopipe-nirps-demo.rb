class EsopipeNirpsDemo < Formula
  desc "ESO NIRPS instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-demo-reflex-0.4.0.tar.gz"
  sha256 "9c594d3f1db6c44d6f80aa6085557adf14f32d3f962c04e481a2f920255cf782"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?nirps-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-nirps"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/nirps").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-nirps-demo"
  end

  test do
    system "true"
  end
end
