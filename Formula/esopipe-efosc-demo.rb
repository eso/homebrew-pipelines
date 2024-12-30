class EsopipeEfoscDemo < Formula
  desc "ESO EFOSC instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/efosc/efosc-demo-reflex-0.1.tar.gz"
  sha256 "c1da7914cd6a436210265717c8ca336174f966b4c09255def4f8488525c22abd"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?efosc-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-efosc"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/efosc").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-efosc-demo"
  end

  test do
    system "true"
  end
end
