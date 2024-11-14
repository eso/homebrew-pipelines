class EsopipeCr2reDemo < Formula
  desc "ESO CR2RES instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/cr2res/cr2re-demo-reflex-1.2.0.tar.gz"
  sha256 "d7a1bac1a3d295b8f1b85f43872ec0a5ff88e92163ef1cf650e7ec7eff51b62a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cr2re-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-cr2re"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/cr2re").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-cr2re-demo"
  end

  test do
    system "true"
  end
end
