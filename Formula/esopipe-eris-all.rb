class EsopipeErisAll < Formula
  desc "ESO ERIS instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/eris/eris-demo-reflex-0.5.tar.gz"
  sha256 "e71c383dd6e148e10c72e445e93623a51e34d7451aad0a5c1c41c78b1c403cd9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?eris-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-eris"

  def install
    (prefix/"share/esopipes/datademo/eris").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-eris-all"
  end

  test do
    system "true"
  end
end
