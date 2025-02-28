class EsopipeCrires < Formula
  desc "ESO CRIRES instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19-5.tar.gz"
  sha256 "7a1d6fb3aad68142af6adb8e23e2d7172bd7779887dd5123126a3101d12531d3"
  license "GPL-2.0-or-later"

  def pipeline
    "crire"
  end

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-crires-recipes"

  def install
    system "tar", "xf", "#{pipeline}-calib-#{version.major_minor_patch}.tar.gz"
    (prefix/"share/esopipes/datastatic/#{pipeline}-#{version.major_minor_patch}").install Dir["#{pipeline}-calib-#{version.major_minor_patch}/cal/*"]
  end

  test do
    system "true"
  end
end
