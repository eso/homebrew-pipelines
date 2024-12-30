class EsopipeVimosDemo < Formula
  desc "ESO VIMOS instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/vimos/vimos-demo-reflex-0.5.tar.gz"
  sha256 "4b7b6d528823a59832e4cd4021fd536b0fc6f5f91da54d25d2198e275f1a8145"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?vimos-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-vimos"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/cr2re").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-vimos-demo"
  end

  test do
    system "true"
  end
end
