class EsopipeIiinstrumentDemo < Formula
  desc "ESO IIINSTRUMENT instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/iiinstrument-demo-reflex-0.6.tar.gz"
  sha256 "7af3c792ba6a8968ffc142bf9754857cf9e4c4f106ff88861be7db45845f25c8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?iiinstrument-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-iiinstrument"
  depends_on "esoreflex"

  def install
    (prefix/"share/esopipes/datademo/iiinstrument").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-iiinstrument-demo"
  end

  test do
    system "true"
  end
end
