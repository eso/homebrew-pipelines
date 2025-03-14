class EsopipeCr2reRecipes < Formula
  desc "ESO CR2RES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/cr2res/cr2re-kit-1.6.7.tar.gz"
  sha256 "f2ff405637b050c50f4d9ab1423f044be3d5b2a2b307069d46dde68ee4df13e4"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cr2re-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-cr2re-recipes-1.6.7"
    sha256 cellar: :any,                 arm64_sequoia: "f2498d97af0ca60b0872971066c63c4a649818f8bf50e6c2273c6494db0fc0ce"
    sha256 cellar: :any,                 arm64_sonoma:  "03d68a11a7012e4bc3231350cf7dcf08819326821d0015c7000af28ab2ba95a7"
    sha256 cellar: :any,                 ventura:       "0da135e0f3656633dae5bbd568963ec72c3fef0f7df38f54a98f786765e388fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577b0bb1c87c4fe7f4742968491e19aa30c7284452e778db58369373697b54da"
  end

  def name_version
    "cr2re-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
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
