class EsopipeErisDemo < Formula
  desc "ESO ERIS instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/eris/eris-demo-reflex-0.6.tar.gz"
  sha256 "ef91ab22abf05198f1c17cabf0bdfb7b5328602534ccff603faa3e866f460a4e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?eris-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-eris"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/eris").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-eris-demo"
  end

  test do
    system "true"
  end
end
