class EsopipeUvesRecipes < Formula
  desc "ESO UVES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/uves/uves-kit-6.5.3-6.tar.gz"
  sha256 "37189eb0628b69688968d3305f625f8763df19832dcb20f9edbfecfe0ae814a5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?uves-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-uves-recipes-6.5.3-6"
    sha256 cellar: :any, arm64_tahoe:   "8d973deaa0ec4aa76e6cbf7e3fca99eae96533e61787e0d3640510a16ac24a86"
    sha256 cellar: :any, arm64_sequoia: "b29130d0e1ed01861f7424fb6646578024bf0f7f5d17294d5a3df572cc76b529"
    sha256 cellar: :any, arm64_sonoma:  "21af549cd64862478ed8bd0b69031cdfa02a63c71b9b648786ae94ad972e1a6e"
    sha256 cellar: :any, sonoma:        "546abb9a1aad27f3e8f658f0bc536080bf51fc489bf5a996764fc387adbdab91"
    sha256 cellar: :any, x86_64_linux:  "ce7c08d1a33bda5ec50d095cf9d9b06039ed5e98cf9577e1aabd2b6ccdffc0ce"
  end

  def name_version
    "uves-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
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
    assert_match "uves_cal_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page uves_cal_mbias")
  end
end
