class EsopipeIiinstrumentRecipes < Formula
  desc "ESO example template instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/iiinstrument-kit-0.1.14-50.tar.gz"
  sha256 "b08f398d81afce30edc968ce8b5361051d2f545c28e3ec4690c1648e3ee1f134"
  license "GPL-2.0-or-later"
  revision 2

  def name_version
    "iiinstrument-#{version.major_minor_patch}"
  end

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/"
    regex(/href=.*?iiinstrument-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-iiinstrument-recipes-0.1.14-50_2"
    sha256 cellar: :any,                 arm64_sequoia: "33f6efb2e8ccfd7cd535c2dc8bcbfbe7435dedc21c2dcbac8561e39a5af9d471"
    sha256 cellar: :any,                 arm64_sonoma:  "e9e8507db39d2124e9b0a605600bfe677ac3a5e274f8fb9275a835841ddb98b6"
    sha256 cellar: :any,                 ventura:       "1e82618fca07554b518b2105a32a632563e20371b1a7f437dd2d0a91c10cca86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "391764427a0ba99aa522765ef84e418249a9d9b7c7212717f64c30ff64f14b68"
  end

  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "gsl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
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
    assert_match "rrrecipe -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page rrrecipe")
  end
end
