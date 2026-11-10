class EsopipeGravity < Formula
  desc "ESO GRAVITY instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/gravity-kit-1.12.0-1.tar.gz"
  sha256 "acf961dbf804904628940ec6166ea1b3e0b08b1304eb1a5fa98ad859db4384eb"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?gravity-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-gravity-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "gravity-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/gravity-#{version_norevision}").install Dir["gravity-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
