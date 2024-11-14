class EsopipeKmosDemo < Formula
  desc "ESO KMOS instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/kmos/kmos-demo-reflex-2.2.0.tar.gz"
  sha256 "52a556b4679bd710ca8070668deeebd44d28f0130310e95bda876151834479fe"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?kmos-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-kmos"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/kmos").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-kmos-demo"
  end

  test do
    system "true"
  end
end
