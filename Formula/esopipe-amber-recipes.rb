class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-10.tar.gz"
  sha256 "62231d6512f6f509cbd134c5d349a8959b29acc53ca22998db7c00ce21cd1bf6"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-10_1"
    sha256 cellar: :any,                 arm64_tahoe:   "467acb854be96a7d643210dbc37f80c56816d28a3ccf548a158d1cdefa33913d"
    sha256 cellar: :any,                 arm64_sequoia: "2474cf32c0511e8bf25e5549d961f2643a820b6308fcc9c4cc0c1b590ce661ed"
    sha256 cellar: :any,                 arm64_sonoma:  "2a2e155635b33ac754bd6437b977efed11c1c0cea0be8a3db51970659bbedc07"
    sha256 cellar: :any,                 sonoma:        "06b70c2321eb9927e27d897f5fe0858bf80829e723b7d805d4f7ffa633de965e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0343aa3b5327840e473af410e50a38e0e8e1d5e729cd50760209273d02e6a8ba"
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
