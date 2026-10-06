class EsopipeGravityDemo < Formula
  desc "ESO GRAVITY instrument pipeline (demo data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/gravity-demo-reflex-0.9.tar.gz"
  sha256 "1c4c3e0bf29f5f6d0187bf1d511d52aa7cd89df35e4799274ff72afb54b5770e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?gravity-demo-reflex-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-gravity"

  def install
    (prefix/"share/esopipes/datademo/gravity").install Dir["*"]
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
