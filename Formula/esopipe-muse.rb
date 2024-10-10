class EsopipeMuse < Formula
  desc "ESO MUSE instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/muse/muse-kit-2.10.10.tar.gz"
  sha256 "d3d51e755a0fdffc21d5730e0041f4e3a4826ec9ffcb97c1f0f69860a7a693df"
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
