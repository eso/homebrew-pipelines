class EsopipeSpherDemo < Formula
  desc "ESO SPHERE instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sphere/spher-demo-reflex-1.5.tar.gz"
  sha256 "4b7458536208e9dd927a65e2e74f141a44f81ee83a8300bb76a964d1b81638d1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?spher-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-spher"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/spher").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-spher-demo"
  end

  test do
    system "true"
  end
end
