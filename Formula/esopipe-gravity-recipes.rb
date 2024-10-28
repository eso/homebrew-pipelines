class EsopipeGravityRecipes < Formula
  desc "ESO GRAVITY instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/gravity-kit-1.7.0-1.tar.gz"
  sha256 "2f3c9025e21f2410166517e613ce8c78f78e3c80ed697661ff2b7fcd688eefc2"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?gravity-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-gravity-recipes-1.7.0-1"
    sha256 cellar: :any,                 arm64_sonoma: "37946680aaebc13b338c06d0acf2318e50727d670b9c50371157955c71dfd085"
    sha256 cellar: :any,                 ventura:      "9bb034ffcac156c76286327f9b82c3a067d8834cdf916962d5e0ad714b4c05d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bb454360ebb0550adc22aed46153971b285c9baa525403ba7c4a0c3689b0ee24"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "curl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "gravity-#{version_norevision}.tar.gz"
    cd "gravity-#{version_norevision}" do
      # Fix -flat_namespace being used on Big Sur and later.
      # system "curl", "-O", "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      # system "patch", "configure", "configure-big_sur.diff"
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
    assert_match "gravity_dark -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page gravity_dark")
  end
end
