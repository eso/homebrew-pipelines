class EsopipeVcamDemo < Formula
  desc "ESO VIRCAM instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/vircam/vcam-demo-reflex-0.1.tar.gz"
  sha256 "cf64dc9d4fe11721e4c68c0706d9b361668e07c1739d04ab84f64253a781dd22"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?vcam-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-vcam"

  def install
    (prefix/"share/esopipes/datademo/cr2re").install Dir["*"]
  end

  def caveats
    <<~EOS
      Demo data can be several gigabytes in size. To reclaim temporary cache space:
        brew cleanup --prune=all #{name}
    EOS
  end

  test do
    system "true"
  end
end
