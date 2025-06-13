class EsopipeGirafRecipes < Formula
  desc "ESO GIRAFFE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/giraffe/giraf-kit-2.18.0-1.tar.gz"
  sha256 "f1dc308e61c047d45a695827cbead1808935928309d0c1e642535656a7f306d6"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?giraf-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-giraf-recipes-2.18.0-1_1"
    sha256 cellar: :any,                 arm64_sequoia: "00f71ad8b51a1df27b14c84a9653dabe62ad74fc0f26df59f61aec8e49ab2fa4"
    sha256 cellar: :any,                 arm64_sonoma:  "0a29750b35f8b35b8b14fe63815dd03c811cd26f002f11d87648ddfa182ed148"
    sha256 cellar: :any,                 ventura:       "f3135edb397a3dd24e242775707800d67d912616490139dd4d75c069b228eb69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbc597e40081e769a43d2042f5027fdbb2584c3678f717bb0b3b1776706c6d42"
  end

  def name_version
    "giraf-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl"
  depends_on "esorex"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}"
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
