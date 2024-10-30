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
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esopipe-nirps-recipes-3.2.0"
    sha256 arm64_sonoma: "d97b43c18161e5a560c11038cbf83dca098f3efb6fa62611ab37974c1b4c0a23"
    sha256 ventura:      "8482cb88a9607f804329b705e17d2d99a17c72e95e94416a4f701dfa518ae330"
    sha256 x86_64_linux: "052712da4bf429fe59519db0c9834c4fd938901c473d0b99c96cfa1ebf96c489"
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
