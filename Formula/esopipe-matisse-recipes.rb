class EsopipeMatisseRecipes < Formula
  desc "ESO MATISSE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/matisse/matisse-kit-2.2.3-6.tar.gz"
  sha256 "32979cff4861d7c16175ed1a399643ac1164a176f603b1d75088b4483ca1c714"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?matisse-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-matisse-recipes-2.2.3-6"
    sha256 cellar: :any, arm64_tahoe:   "7034b4b25e0431f0d6d45e61f83a8c11a95edbdc3aeaac0f07f9da9411fa2f7f"
    sha256 cellar: :any, arm64_sequoia: "25ab277956564e2e8b8b7f213cdb4d7ad9517b467e1e3a3830749154ef6e57ea"
    sha256 cellar: :any, arm64_sonoma:  "46ce18a1b4f1fb3cca4b5d2b9ec3eb400f4bbcf785a6e63ceef4e0014bcb375c"
    sha256 cellar: :any, sonoma:        "9bbacfe22fe59868638c97a03eeb1a03c2b498ea35214593643654b5cd177142"
    sha256 cellar: :any, x86_64_linux:  "5e8ff4aa7026227c3e5f7162d7b263cf950783a7d63c079cf71e010c493148b4"
  end

  def name_version
    "matisse-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "libcext"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
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
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      end
      if workflow.read.include?("$ROOT_DATA_DIR/reflex_input")
        inreplace workflow, "$ROOT_DATA_DIR/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "mat_wave_cal -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page mat_wave_cal")
  end
end
