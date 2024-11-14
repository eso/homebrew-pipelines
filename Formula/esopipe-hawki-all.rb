class EsopipeHawkiAll < Formula
  desc "ESO HAWKI instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/hawki/hawki-demo-reflex-0.5.tar.gz"
  sha256 "d82285de4b10f18de14469bac1e486e534261dbdf76822fff76dfdfa35302d92"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?hawki-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-hawki"

  def install
    (prefix/"share/esopipes/datademo/hawki").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-hawki-all"
  end

  test do
    system "true"
  end
end
