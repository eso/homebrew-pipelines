class EsopipeCr2re < Formula
  desc "ESO CR2RES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/cr2res/cr2re-kit-1.6.7-1.tar.gz"
  sha256 "3a7ce486f62b7663de30140e67a415cafcba99acea8943a20d195554e5388fc8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cr2re-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-cr2re-recipes"
  depends_on "esopipe-esotk"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "cr2re-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/cr2re-#{version_norevision}").install Dir["cr2re-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
