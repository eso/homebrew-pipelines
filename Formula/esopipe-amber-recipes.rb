class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-17.tar.gz"
  sha256 "372485e50532baceacb966d9163ed5f2e03959226603ea8af59642229a224f88"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-17"
    sha256 cellar: :any, arm64_tahoe:   "55905abb780e614a9661f5d58428386ca556e976b89fe117e9a943fbcc42cf8c"
    sha256 cellar: :any, arm64_sequoia: "c0b156d194c12bd0a5874678bd4b82669c4472fa5d91774fd10762f8faad5cf3"
    sha256 cellar: :any, x86_64_linux:  "6f8bb41e03d7a65f06f98ef9c36c5311859d8345e59f6b8fcb975bec4ff93854"
  end

  def name_version
    "amber-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "fftw"
  depends_on "gsl"
  depends_on "libcext"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
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
