class EsopipeHarpsAll < Formula
  desc "ESO HARPS instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/harps/harps-demo-reflex-0.2.0.tar.gz"
  sha256 "983f8d3989e724854e8df5dc34d4fd198e31ef79f409becaae2c4453de4977fa"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?harps-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-harps"

  def install
    (prefix/"share/esopipes/datademo/harps").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-harps-all"
  end

  test do
    system "true"
  end
end
