class EsopipeSpher < Formula
  desc "ESO SPHERE instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sphere/spher-kit-0.56.0-6.tar.gz"
  sha256 "f99105178a212cb28492612d466d1973a6d0c45a278ed14384b13296f818b1f1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?spher-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-spher-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "spher-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/spher-#{version_norevision}").install Dir["spher-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
