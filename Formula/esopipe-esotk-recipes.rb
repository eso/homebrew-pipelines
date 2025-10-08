class EsopipeEsotkRecipes < Formula
  desc "ESO ESOTK instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/esotk/esotk-kit-1.0.0.tar.gz"
  sha256 "45fed3d008416ec9ba31ccae3b6e53008617b18dc99cca2a4ad7bca145e0c8bd"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?esotk-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-esotk-recipes-1.0.0_1"
    sha256 cellar: :any,                 arm64_tahoe:   "c26299ba2e655b321f7eaccc264e284a53a5d21f14ae7002128298a99214e32a"
    sha256 cellar: :any,                 arm64_sequoia: "4ddd2d92a027e9d774f3447be5108588f6479e61aecd5da785379ff389c2f94a"
    sha256 cellar: :any,                 arm64_sonoma:  "2976c1a1a5fcf0711f57eab1ba839d74c6392449c0ba93d94f6a92ff3c053d08"
    sha256 cellar: :any,                 sonoma:        "de6f80c4a714ab5dde296782e0759579295edf10a853b86d8d0faa58f12ec0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bbd92c3e12dc4572ea9c5045d4067408d1b290706e5730577d5a82cd8bf3c86"
  end

  def name_version
    "esotk-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["fftw"].opt_lib}"
    ENV.prepend "LDFLAGS", "-L#{Formula["wcslib"].opt_lib}"
    ENV.prepend "LDFLAGS", "-L#{Formula["cfitsio"].opt_lib}"

    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
    end
  end

  def post_install
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"
    workflow_dir_1.glob("*.xml").each do |workflow|
      ohai "Updating #{workflow}"
      if workflow.read.include?("CALIB_DATA_PATH_TO_REPLACE")
        inreplace workflow, "CALIB_DATA_PATH_TO_REPLACE", HOMEBREW_PREFIX/"share/esopipes/datastatic"
      end
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE/reflex_input")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "esotk_spectrum1d_combine -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page esotk_spectrum1d_combine")
  end
end
