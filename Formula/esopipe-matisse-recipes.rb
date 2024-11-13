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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-matisse-recipes-2.0.2-1_1"
    sha256 cellar: :any,                 arm64_sequoia: "0d804b6839adfcde9e611e79b486049050b3fc5cc6d34b239923a57a1bd42429"
    sha256 cellar: :any,                 arm64_sonoma:  "114cdb0b5cf0e6167fb744f1015bd8b8482e9ec69b6f57306f68162a12263f71"
    sha256 cellar: :any,                 ventura:       "6d0377f064fa214263355e757ace999b07e6dca7390613e87fbd8926d86ac82c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98612854e1509a73edc81219b042cec7437b7a84b66bcf7b610c6a3f2b055d57"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  uses_from_macos "curl"

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
