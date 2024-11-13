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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-visir-recipes-4.4.5_1"
    sha256 arm64_sequoia: "9ba007dd5c08ed7e60eb3710ea93d25b3470f3008307357170e3a10cc900c398"
    sha256 arm64_sonoma:  "54505374fbbe73763fb6d89e46b48676920d9fdf0f8446539b08a26f035e5549"
    sha256 ventura:       "1962500a55b43ce114fd685a591c5bd3bc26e609e425729f725821a6ce856d13"
    sha256 x86_64_linux:  "3ba363971b79265f0effdfe94193af07c609d40eaa37bf1b9e49994e7e0be8e5"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  uses_from_macos "curl"

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
