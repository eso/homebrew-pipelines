class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-8.tar.gz"
  sha256 "b2a8576ba2fc8ca620b39db7f4ca652375276a10a984183668e5d8479e0778c5"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-8_1"
    sha256 cellar: :any,                 arm64_sequoia: "517de79240c7fe952900fca20ed99e7e8bfe2c0627fa7a28e3fb8bb899b438af"
    sha256 cellar: :any,                 arm64_sonoma:  "13443d17e80aa20023e34b921d33549dee39e47603ff1a4c44519968cb65d811"
    sha256 cellar: :any,                 ventura:       "f835a087d0ba815be81a59eb4984b9714bbe964268f9facdc4c065c79f85b2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b23e61a98beadf8fe352eee6d0245684bb051865d69b71e26e328e927faa8f93"
  end

  def name_version
    "amber-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "fftw"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "amber_calibrate -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page amber_calibrate")
  end
end
