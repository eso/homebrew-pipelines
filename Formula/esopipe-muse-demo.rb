class EsopipeMuseDemo < Formula
  desc "ESO MUSE instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/muse/muse-demo-reflex-1.7.tar.gz"
  sha256 "0afbf54cbc6d4b4be05ce50f7ab11cd782adfc1d62aedb373be1d30dd995b739"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?muse-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-muse"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/muse").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-muse-demo"
  end

  test do
    system "true"
  end
end
