class EsopipeForsDemo < Formula
  desc "ESO FORS instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/fors/fors-demo-reflex-1.0.tar.gz"
  sha256 "5c4a14c90018673aff93dfbd3a176ea7581102a0e23cf4cfd25d66e96ac3b55b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?fors-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-fors"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/fors").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-fors-demo"
  end

  test do
    system "true"
  end
end
