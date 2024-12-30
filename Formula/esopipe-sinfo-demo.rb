class EsopipeSinfoDemo < Formula
  desc "ESO SINFO instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sinfoni/sinfo-demo-reflex-0.3.tar.gz"
  sha256 "0963f8051d47cf841ee84e59dab127b2856cde5f02681839467118da30b54988"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sinfo-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-sinfo"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/sinfo").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-sinfo-demo"
  end

  test do
    system "true"
  end
end
