class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-1.tar.gz"
  sha256 "ab1321479850c42c2eb0f24966dbe91b994cb48e1ccc99f8722206edcc5cca3b"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-1"
    sha256 cellar: :any,                 arm64_sequoia: "a235e75cc5a3be2e963c3ce544a10b86ca9c87d8d29b073935921205954a0aa8"
    sha256 cellar: :any,                 arm64_sonoma:  "64095397e255639e3270c03f8a648123c3c49f48db1fb6353e475ceba0cb3e47"
    sha256 cellar: :any,                 ventura:       "d8a9add84dc682c434b710079e915a7dae6265f53efb7c4a5542d1001e29e247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e8175fffa3b5b14ac605c2382a45b2bab1883a46a97233a4e920c062921b1d2"
  end

  def name_version
    "amber-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio@4.2.0"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "fftw@3.3.9"
  depends_on "gsl@2.6"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
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
    assert_match "amber_calibrate -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page amber_calibrate")
  end
end
