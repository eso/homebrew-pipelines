class EsopipeHawkiRecipes < Formula
  desc "ESO HAWKI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/hawki/hawki-kit-2.5.10-1.tar.gz"
  sha256 "6635b3888e1f75e3aecd73727b0124f71d078367039c20a37d2b76f2d0f684d5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?hawki-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-hawki-recipes-2.5.10-1"
    sha256 cellar: :any,                 arm64_sequoia: "a29338a59fd4c0b2ef133d09c34426b3dc3379e5c093e8fa755b824ed45948c6"
    sha256 cellar: :any,                 arm64_sonoma:  "ae6aea758093b435d697605a83625b69a060196c4913a7efbdf75957c071be20"
    sha256 cellar: :any,                 ventura:       "c65badd75c554d77d6d8cb4f437c344b0efacb159d67af917bcf9be6ee568f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8baf5f4e445cd87cdd27d47a27486b0ddf9ef4138a0e362e5667c7990bd7760"
  end

  def name_version
    "hawki-#{version.major_minor_patch}"
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
    assert_match "hawki_cal_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page hawki_cal_dark")
  end
end
