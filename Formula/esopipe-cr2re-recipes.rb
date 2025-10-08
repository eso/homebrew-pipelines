class EsopipeCr2reRecipes < Formula
  desc "ESO CR2RES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/cr2res/cr2re-kit-1.6.10.tar.gz"
  sha256 "90d4eaf0a07765b22c75671115f67d79b922a06f95aebb2564d22cf418263c4f"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cr2re-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-cr2re-recipes-1.6.10_1"
    sha256 cellar: :any,                 arm64_tahoe:   "c95f5fb659d2b4f543f56699f74fea19463af8766b7ba7f6a0a8c7314faa19c0"
    sha256 cellar: :any,                 arm64_sequoia: "dbac91df9df4bd93f7ef5dbab4f2b1fe1596b991829519cd6a171bee8c63b0bd"
    sha256 cellar: :any,                 arm64_sonoma:  "de2186b055e273a5ab1e581f1728e0dbc3f85b4a65fc944835976d76aff57fae"
    sha256 cellar: :any,                 sonoma:        "b67bee2cc92fc296b11b4bfeb0e7d01f143f6676261f902c6c6e37ba33635672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa9c1ab8cc701c31c90bf45ce1a9cbac7857571a2b22b978ea43486b9b7b8a29"
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
