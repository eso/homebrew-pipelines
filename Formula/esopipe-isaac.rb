class EsopipeIsaac < Formula
  desc "ESO ISAAC instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/isaac/isaac-kit-6.2.5-8.tar.gz"
  sha256 "57ce575da9284554cbe0ce44baabca6d8c1066f776b0e1275d6dd4d44bc6c4e9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?isaac-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  def pipeline
    "isaac"
  end

  depends_on "esopipe-isaac-recipes"

  def install
    system "tar", "xf", "#{pipeline}-calib-#{version.major_minor_patch}.tar.gz"
    (prefix/"share/esopipes/datastatic/#{pipeline}-#{version.major_minor_patch}").install Dir["#{pipeline}-calib-#{version.major_minor_patch}/cal/*"]
  end

  test do
    system "true"
  end
end
