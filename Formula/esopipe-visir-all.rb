class EsopipeVisirAll < Formula
  desc "ESO VISIR instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/visir/visir-demo-reflex-0.4.tar.gz"
  sha256 "727d586819ce3c221fffc97da6e16d570e6b0ee94a33c319fb9aabaab8f547eb"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?visir-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-visir"

  def install
    (prefix/"share/esopipes/datademo/visir").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-visir-all"
  end

  test do
    system "true"
  end
end
