class EsopipeGirafAll < Formula
  desc "ESO GIRAFFE instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/giraffe/giraf-demo-reflex-0.3.tar.gz"
  sha256 "900a4c1928209cf1d71d6c18dac4a98d4d1e92fbb394baac5d1b240f68acac16"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?giraf-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-giraf"

  def install
    (prefix/"share/esopipes/datademo/giraf").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-giraf-all"
  end

  test do
    system "true"
  end
end
