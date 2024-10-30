class EsopipeCr2reRecipes < Formula
  desc "ESO CR2RES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/cr2res/cr2re-kit-1.4.4.tar.gz"
  sha256 "bd4a4d1025ea98ed5372680f877c3b20521109600436c5621e876e994f6f6152"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cr2re-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esopipe-cr2re-recipes-1.4.4"
    sha256 cellar: :any,                 arm64_sonoma: "eb0ea078a0a3ff9e245799c9df77cf1dbc303a76039d4aee2950c66119c7a21a"
    sha256 cellar: :any,                 ventura:      "5ffab45ce21b35046c220a43d885e9023b1d6ac05ea81e22eeedbfa8dfdae0e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a3fd42dc3669cfdd561f738d38757c31f8ff99dad90044ba34e03e7f2d863730"
  end

  depends_on "pkg-config" => :build
  depends_on "cfitsio@4.2.0"
  depends_on "cpl@7.3.2"
  depends_on "curl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "cr2re-#{version_norevision}.tar.gz"
    cd "cr2re-#{version_norevision}" do
      system "./configure", "--prefix=#{prefix}",
             "--with-cfitsio=#{Formula["cfitsio@4.2.0"].prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-erfa=#{Formula["erfa"].prefix}",
             "--with-curl=#{Formula["curl"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}"
      system "make", "install"
    end
    rm_r bin
  end

  test do
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "cr2res_cal_dark -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page cr2res_cal_dark")
  end
end
