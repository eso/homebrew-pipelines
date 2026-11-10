class EsopipeAmber < Formula
  desc "ESO AMBER instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-17.tar.gz"
  sha256 "372485e50532baceacb966d9163ed5f2e03959226603ea8af59642229a224f88"
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
