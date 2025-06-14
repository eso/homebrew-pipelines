class EsopipeGirafRecipes < Formula
  desc "ESO GIRAFFE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/giraffe/giraf-kit-2.18.0-1.tar.gz"
  sha256 "f1dc308e61c047d45a695827cbead1808935928309d0c1e642535656a7f306d6"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?giraf-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-giraf-recipes-2.18.0-1_2"
    sha256 cellar: :any,                 arm64_sequoia: "91924b429ccc001d60183c9cfdf5ed0ec0e1999433a9374182659be75d58a26a"
    sha256 cellar: :any,                 arm64_sonoma:  "85117477a6ae1dfbae9d905efca03aa71a478e4ea468f7d26d2da47e81cb5eec"
    sha256 cellar: :any,                 ventura:       "c5140c3078ee4ae88ef42d54b7b028cb68fa4fddd5a9457caf52064c9b52fcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4afcd668608f37287c01b366bdd3e36515ad5ba1dd920c2bb89d755f38983c60"
  end

  def name_version
    "giraf-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "esorex"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}"
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
    assert_match "gimasterbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page gimasterbias")
  end
end
