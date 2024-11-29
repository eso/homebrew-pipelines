class EsopipeMuseDemo < Formula
  desc "ESO MUSE instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/muse/muse-demo-reflex-1.6.tar.gz"
  sha256 "6227b728b57c45aedd16ad1d3ffc38d39e93e5c7857193b09b756b54b6bb99e4"
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
