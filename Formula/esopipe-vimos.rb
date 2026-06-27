class EsopipeVimos < Formula
  desc "ESO VIMOS instrument pipeline (data static)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/vimos/vimos-kit-4.1.14-5.tar.gz"
  sha256 "dd6b785b18ee9ff4c7f5c475e0f5fcc452a7b7385a8e1ff2e906878bdbd33bfc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?vimos-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  def pipeline
    "vimos"
  end

  depends_on "esopipe-vimos-recipes"

  def install
    system "tar", "xf", "#{pipeline}-calib-#{version.major_minor_patch}.tar.gz"
    (prefix/"share/esopipes/datastatic/#{pipeline}-#{version.major_minor_patch}").install Dir["#{pipeline}-calib-#{version.major_minor_patch}/cal/*"]
  end

  test do
    system "true"
  end
end
