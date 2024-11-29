class EsopipeGravityDemo < Formula
  desc "ESO GRAVITY instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/gravity-demo-reflex-0.8.tar.gz"
  sha256 "d88a9b28ebbd51a2b4133dfb8ff1463b233026d01852e678e302eac9f3ec504d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?gravity-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-gravity"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/gravity").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-gravity-demo"
  end

  test do
    system "true"
  end
end
