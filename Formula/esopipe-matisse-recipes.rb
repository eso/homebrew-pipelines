class EsopipeMatisseRecipes < Formula
  desc "ESO MATISSE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/matisse/matisse-kit-2.0.2-1.tar.gz"
  sha256 "44bb7aeba1b5f91589f78594030fec16a63d04f44db9d08e9253cb3d04288b5b"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?matisse-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esopipe-matisse-recipes-2.0.2-1"
    sha256 cellar: :any,                 arm64_sonoma: "93ba7705486e15495ad91b6e4c00256219883f29db5cff11f47a47a62a932cac"
    sha256 cellar: :any,                 ventura:      "33cbb04b9da67e98f862a03ee37838a55beb827988d83aa28cb97c33411ab1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "023b86016105e505f28f4ddc161b70654e384998f68911c941d39aaf8f11def6"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "curl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "matisse-#{version_norevision}.tar.gz"
    cd "matisse-#{version_norevision}" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-gsl=#{Formula["gsl@2.6"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
    end
  end

  test do
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "mat_wave_cal -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page mat_wave_cal")
  end
end
