class EsopipeVisirRecipes < Formula
  desc "ESO VISIR instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/visir/visir-kit-4.4.5.tar.gz"
  sha256 "8833896bfc1e85e60a3a7d24c015d2ec5ca81807e908a0ca5a70970347d1aaa0"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?visir-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esopipe-visir-recipes-4.4.5"
    sha256 arm64_sonoma: "e62773ca8d8af8a55fe0ca4906ddfd2e48016cb3ad8ca4aade6d04c88d84ebda"
    sha256 ventura:      "241f7dde1aa3c32dad9f63f6df615b8a991b2a2dbe681e6665f43bf65294849f"
    sha256 x86_64_linux: "30c60e8d4afbed591c149d26b6b68a6b756289a985c5304b93b3801306b61656"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "curl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "visir-#{version_norevision}.tar.gz"
    cd "visir-#{version_norevision}" do
      system "./configure",
             "--prefix=#{prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}",
             "--with-erfa=#{Formula["erfa"].prefix}",
             "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
    end
  end

  test do
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "visir_img_dark -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page visir_img_dark")
  end
end
