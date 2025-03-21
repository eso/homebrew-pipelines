class EsopipeEfosc < Formula
  desc "ESO EFOSC instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/efosc/efosc-kit-2.3.11.tar.gz"
  sha256 "d2733147979e490382eb970c761d5282803eea8fa47945022b184a126782b561"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?efosc-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  def pipeline
    "efosc"
  end

  depends_on "esopipe-efosc-recipes"

  def install
    system "tar", "xf", "#{pipeline}-calib-#{version.major_minor_patch}.tar.gz"
    (prefix/"share/esopipes/datastatic/#{pipeline}-#{version.major_minor_patch}").install Dir["#{pipeline}-calib-#{version.major_minor_patch}/cal/*"]
  end

  test do
    system "true"
  end
end
