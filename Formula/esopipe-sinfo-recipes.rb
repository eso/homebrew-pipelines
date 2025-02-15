class EsopipeSinfoRecipes < Formula
  desc "ESO SINFONI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sinfoni/sinfo-kit-3.3.5-1.tar.gz"
  sha256 "15e124020ff7592b6201e13cc40563055050e123857f7cb4fb982e2423db187e"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-sinfo-recipes-3.3.5-1_1"
    sha256 cellar: :any,                 arm64_sequoia: "b43a44321516fedf40a401c9f8dc22bbb6ee31d9af4408a6213dc1427066fe3d"
    sha256 cellar: :any,                 arm64_sonoma:  "7bc841b7a1e61033897d4ea7d26881cd5c878f13020492fd1fb24fe0eee71754"
    sha256 cellar: :any,                 ventura:       "13a206f755b29d746b6cf5ef0ff8e48ad5339e3ba86281232582b60a8e447bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52986f526c039d60410876cb8f96a033b02acb85a64587818175f1366495208e"
  end

  def name_version
    "sinfo-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?sinfo-kit-(\d+(?:[.-]\d+)+)\.t/i)
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
