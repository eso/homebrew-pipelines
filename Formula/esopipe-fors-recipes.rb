class EsopipeForsRecipes < Formula
  desc "ESO FORS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/fors/fors-kit-5.6.5-7.tar.gz"
  sha256 "e492be42ae3b96e48a2a3b2981feff8712fb2d616fd1f3f3f42ba243add2a15b"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?fors-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-fors-recipes-5.6.5-7_2"
    sha256 arm64_sequoia: "b89b5b037d7f334c3906300f0711929e539c519d2d2ced6c18bf1983bce4d343"
    sha256 arm64_sonoma:  "8324ca10d225e51fd636649308a380b30d916b8d5cf9a99fe8582af89b3c3323"
    sha256 ventura:       "6b07e89e49c84915773f0a38db4160cd548e8ae16000c6cd5741d137d07aeac2"
    sha256 x86_64_linux:  "3d3bc1e9b99f857b3d8e870f81a2dd05b6211d0a3def000f08759992010c1d91"
  end

  depends_on "pkg-config" => :build
  depends_on "cfitsio@4.2.0"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"
  depends_on "telluriccorr"

  uses_from_macos "curl"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "fors-#{version_norevision}.tar.gz"
    cd "fors-#{version_norevision}" do
      system "./configure", "--prefix=#{prefix}",
             "--with-cfitsio=#{Formula["cfitsio@4.2.0"].prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-erfa=#{Formula["erfa"].prefix}",
             "--with-telluriccorr=#{Formula["telluriccorr"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}",
             "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
    end
  end

  test do
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "fors_dark -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page fors_dark")
  end
end
