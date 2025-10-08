class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-10.tar.gz"
  sha256 "62231d6512f6f509cbd134c5d349a8959b29acc53ca22998db7c00ce21cd1bf6"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-10"
    sha256 cellar: :any,                 arm64_sequoia: "d88f60733723167ac2f23a4e45249f1fc9e45bcb18e58ce954dd71a07a30495d"
    sha256 cellar: :any,                 arm64_sonoma:  "dabb589dbdff4a804c68d50dd5a2d3fb81e538ad254dd6c6854feeda983f4696"
    sha256 cellar: :any,                 ventura:       "10153908e6d8c15c9c6ffa42bf9b98596be958ca2942dd1d4c11e45490097ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e758b56164c31a07e8b3d28a7c2c52655dc4e54466e9dccf99635218a1cc863"
  end

  def name_version
    "amber-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "fftw"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "amber_calibrate -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page amber_calibrate")
  end
end
