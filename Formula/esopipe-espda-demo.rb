class EsopipeEspdaDemo < Formula
  desc "ESO ESPRESSO-DAS instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso-das/espda-demo-reflex-0.9.5.tar.gz"
  sha256 "0a03aa51ad2b5037820fcef28ccb2572737b05a946cff322e5c393ddfd49a0e5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?espda-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-espda"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/espda").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-espda-demo"
  end

  test do
    system "true"
  end
end
