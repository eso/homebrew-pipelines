class EsopipeCr2reRecipes < Formula
  desc "ESO CR2RES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/cr2res/cr2re-kit-1.6.7-1.tar.gz"
  sha256 "3a7ce486f62b7663de30140e67a415cafcba99acea8943a20d195554e5388fc8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cr2re-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-cr2re-recipes-1.6.7_2"
    sha256 cellar: :any,                 arm64_sequoia: "74c2d656e1a9a49c29b42e37d617ca9cb8e0af68f84a89018ea5e68416ad98f1"
    sha256 cellar: :any,                 arm64_sonoma:  "d0b6c61ceeee7e74509a00eda50696eb1fc18d6758be07d23c6e569f88da094d"
    sha256 cellar: :any,                 ventura:       "37b81ff854257bc87c78937b6ff8566fe85209ca99e1a38143640e2eea62d69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c1f7f222795b802a61b4a39f33008fed47663c44e807e26ee86ea6d0141eda9"
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
