class EsopipeSpherRecipes < Formula
  desc "ESO SPHERE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sphere/spher-kit-0.56.0.tar.gz"
  sha256 "0c06cfa743b85fbf2980d0dbdb1bcf8cf57ea591e1f1cec987d6ca4abdc25157"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?spher-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esopipe-spher-recipes-0.53.2"
    sha256 cellar: :any,                 arm64_sonoma: "d7887a9ba6a2bcba593aa96f1b527d449c964bbaad0ab6286ea256ed11cc5c0c"
    sha256 cellar: :any,                 ventura:      "44fc216d015e8b2feacccd931126dcfaf8ed1c9274d0afeae961ccb53bb00470"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8555b7a7d0af5337b3bb01a2b53b9c41af7696ca23dc4000235020b51367fd24"
  end

  depends_on "pkg-config" => :build
  depends_on "cfitsio@4.2.0"
  depends_on "cpl@7.3.2"
  depends_on "curl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["fftw@3.3.9"].opt_lib}"
    ENV.prepend "LDFLAGS", "-L#{Formula["wcslib@7.12"].opt_lib}"
    ENV.prepend "LDFLAGS", "-L#{Formula["cfitsio@4.2.0"].opt_lib}"

    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "spher-#{version_norevision}.tar.gz"
    cd "spher-#{version_norevision}" do
      system "./configure", "--prefix=#{prefix}",
             "--with-cfitsio=#{Formula["cfitsio@4.2.0"].prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-erfa=#{Formula["erfa"].prefix}",
             "--with-curl=#{Formula["curl"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}"
      system "make", "install"
    end
  end

  test do
    # version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "sph_zpl_master_dark -- version",
                 shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page sph_zpl_master_dark")
  end
end
