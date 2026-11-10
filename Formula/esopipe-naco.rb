class EsopipeNaco < Formula
  desc "ESO NACO instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/naco/naco-kit-4.4.13-16.tar.gz"
  sha256 "d1f63eaeec3ba6792cd8ffbc756eb06e403abdbcdbf56c03166c39dc3b5c7909"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?naco-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  def pipeline
    "naco"
  end

  depends_on "esopipe-naco-recipes"

  def install
    system "tar", "xf", "#{pipeline}-calib-#{version.major_minor_patch}.tar.gz"
    (prefix/"share/esopipes/datastatic/#{pipeline}-#{version.major_minor_patch}").install Dir["#{pipeline}-calib-#{version.major_minor_patch}/cal/*"]
  end

  test do
    system "true"
  end
end
