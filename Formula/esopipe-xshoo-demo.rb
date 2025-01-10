class EsopipeXshooDemo < Formula
  desc "ESO XSHOOTER instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/xshooter/xshoo-demo-reflex-1.3.tar.gz"
  sha256 "e3307f8fe16559e211dfff643665ed28a10182e4244f9fe3f85c9f13eed460a5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?xshoo-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-xshoo"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/xshooter").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-xshoo-demo"
  end

  test do
    system "true"
  end
end
