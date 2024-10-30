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
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esopipe-giraf-recipes-2.16.12_1"
    sha256 cellar: :any,                 arm64_sonoma: "8c4eb499ef2af4f0910f6f325ea7b354c3a89e065b77d85f970fc1ab6cbc28cc"
    sha256 cellar: :any,                 ventura:      "62df1fb985b8064e2493692624353774e051920a33b594d6363594c2c147f183"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e7ea3509c8daa59d42f2ec8decf6e765341730d460977f86678e4946c96e5bb1"
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
