class EsopipeSofi < Formula
  desc "ESO SOFI instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sofi/sofi-kit-1.5.16-6.tar.gz"
  sha256 "ca285dfa3cb12eb13ebfbbc03f2a9dec47f4ce1a7e07ba70119aac5b615c7840"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sofi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  def pipeline
    "sofi"
  end

  depends_on "esopipe-sofi-recipes"

  def install
    system "tar", "xf", "#{pipeline}-calib-#{version.major_minor_patch}.tar.gz"
    (prefix/"share/esopipes/datastatic/#{pipeline}-#{version.major_minor_patch}").install Dir["#{pipeline}-calib-#{version.major_minor_patch}/cal/*"]
  end

  test do
    system "true"
  end
end
