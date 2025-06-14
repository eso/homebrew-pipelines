class EsopipeSofiRecipes < Formula
  desc "ESO SOFI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sofi/sofi-kit-1.5.16-6.tar.gz"
  sha256 "ca285dfa3cb12eb13ebfbbc03f2a9dec47f4ce1a7e07ba70119aac5b615c7840"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?sofi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-sofi-recipes-1.5.16-6_2"
    sha256 cellar: :any,                 arm64_sequoia: "193de2226a190414e249517cce9fa4a5c66b4145dd17c480e5359d84a2672abd"
    sha256 cellar: :any,                 arm64_sonoma:  "49ea9e16e3c75dff77f8d627f32ed1015e3ff4bfcf815838650251d2d22fb413"
    sha256 cellar: :any,                 ventura:       "8bb18e2074aa5b3567295926e22e8460e41a84eea6eab794d4ba74f4ae5750df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6f66b78794e67680cba2afc02bece3b6237d056b36add93a38af1c7bd2af4f1"
  end

  def name_version
    "sofi-#{version.major_minor_patch}"
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
    assert_match "sofi_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page sofi_img_dark")
  end
end
