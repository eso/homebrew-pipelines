class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-13.tar.gz"
  sha256 "25c33eb64b8c040cc5f50fe80293f2530ef3ff609c758abea1eb73116078a3b3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-13"
    sha256 cellar: :any,                 arm64_tahoe:   "0d753c053248b41bc9008f557678a59879743ed0d292d40c3a1d9fefbd484158"
    sha256 cellar: :any,                 arm64_sequoia: "50a8fac95427a16397ec51f2150e5cdc97ef4f5def007b4b6164a84fb1c37934"
    sha256 cellar: :any,                 arm64_sonoma:  "71732c3011a31f861daef5f45d90af71ec26d20df25d794ea8b7921dca9be5ff"
    sha256 cellar: :any,                 sonoma:        "7b2f897d4857dc618f12a4dd0e06b4df908161b50d6bc0b113524f4c349c3565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "460efe19b1e68b6be04efba8b12008aa26737157f06bc73cead5000d89a3319f"
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
