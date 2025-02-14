class EsopipeSinfoRecipes < Formula
  desc "ESO SINFONI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sinfoni/sinfo-kit-3.3.5-1.tar.gz"
  sha256 "15e124020ff7592b6201e13cc40563055050e123857f7cb4fb982e2423db187e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sinfo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-sinfo-recipes-3.3.5-1"
    sha256 cellar: :any,                 arm64_sequoia: "4879375d480c405286c8ba4a4f376abd60d1b273dc769df39322d76e0bac5883"
    sha256 cellar: :any,                 arm64_sonoma:  "ae8575d5319b221e672281a06f334c4984dcc9625f3bc184f729ff4d444cf7c5"
    sha256 cellar: :any,                 ventura:       "d52a4d1f65563c9a7c4095e2e02eb2a4d527e74e44c354ab3d4688faa2145cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb903b8285340a757247ac178b59b82b2ddf2f474c7393b6bd3eb6dd871a0da"
  end

  def name_version
    "sinfo-#{version.major_minor_patch}"
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
