class EsopipeEspdaRecipes < Formula
  desc "ESO ESPRESSO-DAS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso-das/espda-kit-1.3.8.tar.gz"
  sha256 "d100d9c4318fcfd853f445413ee5a73ad8ca5f41f359ea016afae3758e7e33d6"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?espda-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esopipe-espda-recipes-1.3.8"
    sha256 cellar: :any,                 arm64_sonoma: "8aa42406f5fe74486250adc31402290482bbd2b1bb75fee568eeb9d25235b34a"
    sha256 cellar: :any,                 ventura:      "5b267f1bacf5c696e7970f9d844c67040286c56b4a35ab9dc91a8a098becfd7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8d73d3191adecda9e3359f6f2a477eb0692d9573477903a81bcb2efd28312539"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "espda-#{version_norevision}.tar.gz"
    cd "espda-#{version_norevision}" do
      system "./configure",
             "--prefix=#{prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}"
      system "make", "install"
    end
  end

  test do
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "espda_fit_line -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page espda_fit_line")
  end
end
