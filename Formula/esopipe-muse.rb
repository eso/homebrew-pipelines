class EsopipeMuse < Formula
  desc "ESO MUSE instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/muse/muse-kit-2.11.5-2.tar.gz"
  sha256 "08e5b85800a6047af88e13b7fa74905872858689df465e54452e2f5a432f9765"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?muse-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-muse-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "muse-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/muse-#{version_norevision}").install Dir["muse-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
