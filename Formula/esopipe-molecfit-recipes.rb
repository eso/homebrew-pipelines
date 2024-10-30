class EsopipeMolecfitRecipes < Formula
  desc "ESO MOLECFIT instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.3.3.tar.gz"
  sha256 "1b33df7da828d9be81fb54ad5251e236ffa8e53ceaa43c746a08b28ec8e84fc2"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?molecfit-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esopipe-molecfit-recipes-4.3.3"
    sha256 cellar: :any,                 arm64_sonoma: "f55fe564bba4e6dbbdc1ac09f5d562695dbd4e179e230e2ddf9283d726151ee7"
    sha256 cellar: :any,                 ventura:      "190a72e58636bb7be76f17f1e4969a009b5a78831fd60a53d27c5c901c01ac79"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e028dfc63a404dcf05a95e4dfd91496ad156ba5fb3d9e176580d2cff86cadcc1"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "telluriccorr"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "molecfit-#{version_norevision}.tar.gz"
    cd "molecfit-#{version_norevision}" do
      system "./configure", "--prefix=#{prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-telluriccorr=#{Formula["telluriccorr"].prefix}"
      system "make", "install"
    end
  end

  test do
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "molecfit_model -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page molecfit_model")
  end
end
