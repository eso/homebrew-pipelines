class EsopipeSofiRecipes < Formula
  desc "ESO SOFI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sofi/sofi-kit-1.5.16-11.tar.gz"
  sha256 "777e01861b3631c0013409cd90e554e700630278e141f4f4c5549a406f723ee3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sofi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-sofi-recipes-1.5.16-11"
    sha256 cellar: :any, arm64_tahoe:   "e8927c9d59ab48afc667f424dfb7efe107ef8959bf30aaa2c19a2e6c5200e3e3"
    sha256 cellar: :any, arm64_sequoia: "c298387f312382c5b491907cdcd946f11f68e90643b80825958feef56d4a7946"
    sha256 cellar: :any, arm64_sonoma:  "74d1c0c6a8701a8d658d3770cc1ea841580e81264fefa49047e47bc459a6c521"
    sha256 cellar: :any, sonoma:        "785d422c4ce5962bfca3da78cf9517f732ce52ae73531edc40ca5077fb131156"
    sha256 cellar: :any, x86_64_linux:  "cc818311900d40c326ba94507cd0c7ab96da9006130b67ec59f96bc5f4199f87"
  end

  def name_version
    "sofi-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "esorex"
  depends_on "gsl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}"
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
    assert_match "sofi_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page sofi_img_dark")
  end
end
