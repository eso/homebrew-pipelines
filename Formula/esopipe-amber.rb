class EsopipeAmber < Formula
  desc "ESO AMBER instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-10.tar.gz"
  sha256 "62231d6512f6f509cbd134c5d349a8959b29acc53ca22998db7c00ce21cd1bf6"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-amber-recipes"

  def install
    system "tar", "xf", "amber-calib-#{version.major_minor_patch}.tar.gz"
    (prefix/"share/esopipes/datastatic/amber-#{version.major_minor_patch}").install Dir["amber-calib-#{version.major_minor_patch}/cal/*"]
  end

  test do
    system "true"
  end
end
