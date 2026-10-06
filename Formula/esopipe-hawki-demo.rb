class EsopipeHawkiDemo < Formula
  desc "ESO HAWKI instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
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
