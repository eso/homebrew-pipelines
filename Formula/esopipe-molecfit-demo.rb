class EsopipeMolecfitDemo < Formula
  desc "ESO MOLECFIT instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-demo-reflex-1.5.tar.gz"
  sha256 "eec222de7d2de2ac554b03d4cfd21991e16ee60cdf4eed658c05b10ef46d4073"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?molecfit-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-molecfit"

  def install
    (prefix/"share/esopipes/datademo/molecfit").install Dir["*"]
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
