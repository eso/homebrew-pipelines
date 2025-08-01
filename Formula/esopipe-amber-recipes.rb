class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-10.tar.gz"
  sha256 "62231d6512f6f509cbd134c5d349a8959b29acc53ca22998db7c00ce21cd1bf6"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-9"
    sha256 cellar: :any,                 arm64_sequoia: "1c31ad81b1f72ce91dd30cb1c2980084801e1df151e73b9525bb391748b25e31"
    sha256 cellar: :any,                 arm64_sonoma:  "425349a330f574d2aa1c563e81c52e8079593f506f4b65b3027499419f72c9f4"
    sha256 cellar: :any,                 ventura:       "22f3902fd74b95ded36d7006986e711514e65dd0cfdb4f74557a90242124586a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eaf35bc27eeda6b16bb6bbb041bb2fadbb090f94bd238606542065c06d4ace6"
  end

  def name_version
    "amber-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
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
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
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
