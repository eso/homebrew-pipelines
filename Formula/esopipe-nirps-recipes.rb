class EsopipeNirpsRecipes < Formula
  desc "ESO NIRPS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-kit-3.2.0.tar.gz"
  sha256 "37bf774cb1b5f5bbe62c35e11b88d3ca592e97ee5a1d05091672b021a92e3530"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?nirps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-nirps-recipes-3.2.0_1"
    sha256 arm64_sequoia: "56d0ef29b76fbbaae861e4c21bf609c4dc4f5cef46deca944d625862af389d71"
    sha256 arm64_sonoma:  "ff965389f32f3a6bb5062a252ed6943edbf516263934296fcc8864a4ea90c695"
    sha256 ventura:       "86d79bc235fbc649a831011d84d991e3adfbc328f3e8865196bcdf1f0f941ea7"
    sha256 x86_64_linux:  "1bfa04bdb4d7cace646192bfb5cc3221439cdb4d84e69ad4e1361c4720ae761b"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "curl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "nirps-#{version_norevision}.tar.gz"
    cd "nirps-#{version_norevision}" do
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
    assert_match "espdr_mbias -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page espdr_mbias")
  end
end
