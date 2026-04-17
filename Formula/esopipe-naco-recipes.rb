class EsopipeNacoRecipes < Formula
  desc "ESO NACO instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/naco/naco-kit-4.4.13-12.tar.gz"
  sha256 "319e633e3656b6650ab7f4989ee7f4319bac899439f4f4099e5b87481f95f37a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?naco-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-naco-recipes-4.4.13-12"
    sha256 cellar: :any,                 arm64_tahoe:   "1208dcc928de2edca17aab5e18f8ef08ca8a305030921d15cbb581fdf17f7e0b"
    sha256 cellar: :any,                 arm64_sequoia: "d81e5993d1b2c62a05765ef66665904180781211dbbf7bddf0e3926e8aa3c554"
    sha256 cellar: :any,                 arm64_sonoma:  "8b6a31e657c9e940f84252ae2d6468813df93d26cde3012096abe4ed3ecc83b4"
    sha256 cellar: :any,                 sonoma:        "c29d46780a6a618433e6bc1491b9dd82f4bd7e07ee35bd269d068dacc390a83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a21e86a975b70913480d73a3697495c4d3399ac42c77947a362fa95dda18e04"
  end

  def name_version
    "naco-#{version.major_minor_patch}"
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
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
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
    assert_match "naco_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page naco_img_dark")
  end
end
