class EsopipeSinfo < Formula
  desc "ESO SINFONI instrument pipeline (recipe datastatic)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sinfoni/sinfo-kit-3.3.6-7.tar.gz"
  sha256 "c85e316e142e2f5602c6abb0172ab5e6b10b8051cf0e826fae0cda49eb7b541f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sinfo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  def pipeline
    "sinfo"
  end

  depends_on "esopipe-sinfo-recipes"

  def install
    system "tar", "xf", "#{pipeline}-calib-#{version.major_minor_patch}.tar.gz"
    (prefix/"share/esopipes/datastatic/#{pipeline}-#{version.major_minor_patch}").install Dir["#{pipeline}-calib-#{version.major_minor_patch}/cal/*"]
  end

  test do
    system "true"
  end
end
