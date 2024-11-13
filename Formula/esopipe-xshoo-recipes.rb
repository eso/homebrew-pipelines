class EsopipeXshooRecipes < Formula
  desc "ESO XSHOOTER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/xshooter/xshoo-kit-3.6.8.tar.gz"
  sha256 "e50f7172d65de8b8f54fc47a333d49a5fa6db34aabe097bbc1a3449f455ab2b9"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?xshoo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-xshoo-recipes-3.6.8_2"
    sha256 cellar: :any,                 arm64_sequoia: "85e0c3489d05f4ecd7898a4dbe22f5d92de0fb94be793c6051c4d6d99ec6fb47"
    sha256 cellar: :any,                 arm64_sonoma:  "41b0536022b37a76dcd0fb603b13fdb39d95e14275b721e10b0e7a67610f4d87"
    sha256 cellar: :any,                 ventura:       "2d48c48e835aad466c296a0fbc9279ee13db33fd1949093c8f577e0f32a12d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7855c75e23c88a829d04cd66046f23721fc9a1993b957babf21d50539e41055"
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
    system "tar", "xf", "xshoo-#{version_norevision}.tar.gz"
    cd "xshoo-#{version_norevision}" do
      system "./configure", "--prefix=#{prefix}",
             "--with-cfitsio=#{Formula["cfitsio@4.2.0"].prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-erfa=#{Formula["erfa"].prefix}",
             "--with-curl=#{Formula["curl"].prefix}",
             "--with-telluriccorr=#{Formula["telluriccorr"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}"
      system "make", "install"
    end
  end

  test do
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "xsh_mdark -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page xsh_mdark")
  end
end
