class EsopipeHarpsRecipes < Formula
  desc "ESO HARPS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/harps/harps-kit-3.2.0.tar.gz"
  sha256 "137cc5dc4b2cda9f2615e43423a135baf2b174eece183b7b0b7af832b8abef99"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?harps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-harps-recipes-3.2.0_1"
    sha256 arm64_sequoia: "14ea6b6b75ed72ff163f2e7a491f47598c544bccb421857ec2c2558c0a3e95c9"
    sha256 arm64_sonoma:  "16728d421e0358cadf8d9b15388a58287c60afef75797821c7d8c03ad7d58051"
    sha256 ventura:       "d03263fa64ebcf7cf98868f3d1cc04521ace1c7920ab6d1733a8aea3fee50c54"
    sha256 x86_64_linux:  "25aa266b1cb44acbd5657e9269b201fe150b06a5f7752b58eb6757b26feaa48a"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "curl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "harps-#{version_norevision}.tar.gz"
    cd "harps-#{version_norevision}" do
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
