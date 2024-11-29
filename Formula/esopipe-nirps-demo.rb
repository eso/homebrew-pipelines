class EsopipeNirpsDemo < Formula
  desc "ESO NIRPS instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-demo-reflex-0.4.0.tar.gz"
  sha256 "e5f1ce70c7acd1dd026f51c4f96e64cb5c9d720db852e718c25a2ea3586fdf92"
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
