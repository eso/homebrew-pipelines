class EsopipeSinfoRecipes < Formula
  desc "ESO SINFONI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sinfoni/sinfo-kit-3.3.6-6.tar.gz"
  sha256 "7f4f4a652d2c0e83091425f9bf27b1f1d2f76b88590f8704626b24a2dd6ef093"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?sinfo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-sinfo-recipes-3.3.6-6_1"
    sha256 cellar: :any,                 arm64_sequoia: "2cc5b6de8e00247de6478a95f4571414f3ab5b5a783e156822a40b2d10994d3f"
    sha256 cellar: :any,                 arm64_sonoma:  "9e992195ebf9e93df0eb6a53accdaa91002004822b893d14add65087d72a27fd"
    sha256 cellar: :any,                 ventura:       "14e92dadb65e2b7f95a3c0d68140713015af6a527ca8603b7d936b5fa64667c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a22151ae53680983d275ec373b1623a27a7a7fce88abf264f09aeeee8459bb7"
  end

  def name_version
    "sinfo-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
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
    assert_match "sinfo_rec_mdark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page sinfo_rec_mdark")
  end
end
