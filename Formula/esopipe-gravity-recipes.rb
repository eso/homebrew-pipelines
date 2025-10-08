class EsopipeGravityRecipes < Formula
  desc "ESO GRAVITY instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/gravity-kit-1.9.6.tar.gz"
  sha256 "a7fe48a9819dde30f3855b0dea98004ea0f736ddea2dc9f6eb0426a79ca3e730"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?gravity-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-gravity-recipes-1.9.6_1"
    sha256 cellar: :any,                 arm64_tahoe:   "1beceb13cf62ffacf46769c50d6ea5a4ac8c876628c201a89f6c285c115a9b4b"
    sha256 cellar: :any,                 arm64_sequoia: "2706ccb4df653c504ba8dbd806bf1e068329018d4511ae3d04259689b4920136"
    sha256 cellar: :any,                 arm64_sonoma:  "64883fb0697daed40a4cf8ff2c72afd4edc03a138bf5e7d6969a53dfc8304a05"
    sha256 cellar: :any,                 sonoma:        "e833dcaef3985f340556a0114f9695c936286cd3d2e47544f9128a10b98f0194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7ff62c497656f657419506484c9668c81ee30bcc1dd6bb4394b4ba58749ae4b"
  end

  def name_version
    "gravity-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
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
    assert_match "gravity_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page gravity_dark")
  end
end
