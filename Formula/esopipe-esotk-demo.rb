class EsopipeEsotkDemo < Formula
  desc "ESO ESOTK instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/esotk/esotk-demo-reflex-0.9.tar.gz"
  sha256 "3a7ae267a1130b0282a866020c7dc207c54d8d02ccc20b1739fe724e2826831c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?esotk-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-esotk"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/esotk").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-esotk-demo"
  end

  test do
    system "true"
  end
end
