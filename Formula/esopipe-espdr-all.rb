class EsopipeEspdrAll < Formula
  desc "ESO ESPRESSO instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso/espdr-demo-reflex-0.7.0.tar.gz"
  sha256 "540211e9487db3a862db20005b4ae65a9edc1c9f200731a8038945c72cba370c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?espdr-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-espdr"

  def install
    (prefix/"share/esopipes/datademo/espdr").install Dir["*"]
  end

  def post_install
    system "brew", "cleanup", "--prune=all", "esopipe-espdr-all"
  end

  test do
    system "true"
  end
end
