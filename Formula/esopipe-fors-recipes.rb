class EsopipeForsRecipes < Formula
  desc "ESO FORS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/fors/fors-kit-5.8.2.tar.gz"
  sha256 "dfba4f6a8e1376629ac5a76ece092711433c1905455afe47cecde759eb8149eb"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?fors-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-fors-recipes-5.8.1-1_1"
    sha256 arm64_sequoia: "03024aed0648896b29ba41ca4360a619e97d26354840b100524466c6c0be6036"
    sha256 arm64_sonoma:  "9358bd50f8d94d263fca8fe6ee858fd7a80606063c9674aee03a696c529c0f2c"
    sha256 ventura:       "6cc9213e79162eb68776717a41961f2ca55a8442b9285d58b6d0d929387c599a"
    sha256 x86_64_linux:  "617f82cbd01939b4a0622624c32445f7f3ab1a239648b287044179f6296ce0d5"
  end

  def name_version
    "fors-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "telluriccorr"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
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
      if workflow.read.include?("RAW_DATA_PATH_TO_REPLACE/")
        inreplace workflow, "RAW_DATA_PATH_TO_REPLACE/", HOMEBREW_PREFIX/"share/esopipes/datademo/fors"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "fors_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page fors_dark")
  end
end
