class EsopipeSofiRecipes < Formula
  desc "ESO SOFI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sofi/sofi-kit-1.5.16-6.tar.gz"
  sha256 "ca285dfa3cb12eb13ebfbbc03f2a9dec47f4ce1a7e07ba70119aac5b615c7840"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sofi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-sofi-recipes-1.5.16-6"
    sha256 cellar: :any,                 arm64_sequoia: "b68421a666c84e47b6085a4145f0714b908d6f0eaadd11c44945006f843814e8"
    sha256 cellar: :any,                 arm64_sonoma:  "0622c38c5a143b389028b36c4aa8f226b2095ce8287332fbbe4be8249429e9d6"
    sha256 cellar: :any,                 ventura:       "672222913438ef077c3153d01c35f0feb44cda9834ddf32a5ec4fb3b7ef073c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "327092438de8c8af24b6b0a3be55e614831464c3f51894f58ebf685dc404993a"
  end

  def name_version
    "sofi-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl"
  depends_on "esorex"
  depends_on "gsl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
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
