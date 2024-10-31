class EsopipeGirafRecipes < Formula
  desc "ESO GIRAFFE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/giraffe/giraf-kit-2.16.12.tar.gz"
  sha256 "6920f5a672fd2f8bb312180e922707707e747661e6767897bb229afa4da89a04"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?giraf-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-giraf-recipes-2.16.12_2"
    sha256 cellar: :any,                 arm64_sequoia: "8c937d9f77ceb5a29875174e64e5e51df2f42f51e5f30a0b93d488a6dcd1a6c4"
    sha256 cellar: :any,                 arm64_sonoma:  "b3a8d98cf13bbab1fa0c2f3dddd9d625dee3a2896398f6763c72ab6a822910e0"
    sha256 cellar: :any,                 ventura:       "209167a42012a196e2f7d9eed58e73432c31c8ac16128a92d70972f8330c9c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d445c9cb144dbddc923f31e02cc3eefbb9df3e0eb37b922b93fcbb71ecb14d14"
  end

  depends_on "pkg-config" => :build
  depends_on "cfitsio@4.2.0"
  depends_on "cpl@7.3.2"
  depends_on "esorex"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "giraf-#{version_norevision}.tar.gz"
    cd "giraf-#{version_norevision}" do
      system "./configure", "--prefix=#{prefix}",
             "--with-cfitsio=#{Formula["cfitsio@4.2.0"].prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}"
      system "make", "install"
    end
  end

  test do
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "gimasterbias -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page gimasterbias")
  end
end
