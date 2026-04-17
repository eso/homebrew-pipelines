class EsopipeCr2reRecipes < Formula
  desc "ESO CR2RES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/cr2res/cr2re-kit-1.6.11-3.tar.gz"
  sha256 "2d2c88522ee1cefdab7ae2a7179552e7bf2f917e70d97942428c7a2e324a6ad1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cr2re-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-cr2re-recipes-1.6.11-3"
    sha256 cellar: :any,                 arm64_tahoe:   "ccf6f1fee4bfa973799e8f24f3d4c81c78c6e4344246b2784d00298b2fb703c4"
    sha256 cellar: :any,                 arm64_sequoia: "39a515cf01dd026c39137b5822a39e836e49e9509c9c3301f60dae9ac567317c"
    sha256 cellar: :any,                 arm64_sonoma:  "9372619987cd71be9c69340605daa1f8f9437ec8cc74a1f30d298254f589e9a9"
    sha256 cellar: :any,                 sonoma:        "ee9d54b7c4e3bd3f085b66f4e915e43e92d3afb6c6a475b2423f415bcf491d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dcdb7dea9e71edb5f227fbcdefbed627013d3c82166ab3a9b05897aa7f030a5"
  end

  def name_version
    "cr2re-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
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
    rm_r bin
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
    assert_match "cr2res_cal_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page cr2res_cal_dark")
  end
end
