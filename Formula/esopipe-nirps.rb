class EsopipeNirps < Formula
  desc "ESO NIRPS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-kit-3.3.12-6.tar.gz"
  sha256 "e6882c872bcc3c75242274fc78687e92a82b7d9073db4dae01c3224ffb319be0"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?nirps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-nirps-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "nirps-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/nirps-#{version_norevision}").install Dir["nirps-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
