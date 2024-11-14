class EsopipeForsAll < Formula
  desc "ESO FORS instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/fors/fors-demo-reflex-0.9.tar.gz"
  sha256 "80969516bdca461c98b1013d10bd3eb945babaf3e80be3a6db59120f14de1683"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?fors-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-fors"

  def install
    (prefix/"share/esopipes/datademo/fors").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-fors-all"
  end

  test do
    system "true"
  end
end
