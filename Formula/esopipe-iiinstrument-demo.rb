class EsopipeIiinstrumentDemo < Formula
  desc "ESO IIINSTRUMENT instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/iiinstrument-demo-reflex-0.7.tar.gz"
  sha256 "bf6cc118e5503f37cc0eecc72a2b9bf1229431af29433df8d8af0bec39533b7f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/"
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
