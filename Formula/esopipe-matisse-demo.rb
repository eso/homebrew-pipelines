class EsopipeMatisseDemo < Formula
  desc "ESO MATISSE instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/matisse/matisse-demo-reflex-0.4.tar.gz"
  sha256 "32a261163ffe6c7b3b3c93806b23365af69179c65f00351f87789b2b817db6a9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?matisse-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-matisse"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/matisse").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-matisse-demo"
  end

  test do
    system "true"
  end
end
