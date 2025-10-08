class EsopipeHawkiRecipes < Formula
  desc "ESO HAWKI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/hawki/hawki-kit-2.5.13-1.tar.gz"
  sha256 "cede01906426cbfef483c1bb1c238b89c9b25f80cd67e6d6d313b8cd7e553896"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?hawki-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-hawki-recipes-2.5.13-1"
    sha256 cellar: :any,                 arm64_sequoia: "dbd834eb2e73650cb594e8cfe8171b1a2ad5b393014961110f385a2bb027f905"
    sha256 cellar: :any,                 arm64_sonoma:  "1f997c0a06ce431ce07789c4bb5d18b855acd7eb310e36fb8f41c685f8d94687"
    sha256 cellar: :any,                 ventura:       "0238303e09854e67f12278e24502f78be5a905c0be8bff4642652bf404ad0196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8affa027dab3713ddb11bdc0357bda8aeefcb77633688b8645621231e0cedec1"
  end

  def name_version
    "hawki-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "gsl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
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
    assert_match "hawki_cal_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page hawki_cal_dark")
  end
end
