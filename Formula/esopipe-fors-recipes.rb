class EsopipeForsRecipes < Formula
  desc "ESO FORS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/fors/fors-kit-5.8.7-3.tar.gz"
  sha256 "130ae4942fe26cb92c1f7faab514fc0d3aaa21c0978d4a2bc9dcd8a30996328c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?fors-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-fors-recipes-5.8.7-3"
    sha256 arm64_tahoe:   "bdfac800f9193c92289e7916df56094604ff13fc6487bc8d9cdabc605ff1f411"
    sha256 arm64_sequoia: "16929ba9bc34be3959ba68aee32f8c14d6b1f3f6bffedc5259cee3246724350a"
    sha256 x86_64_linux:  "5a387bfde702edf06585824bc83b35a3ec3732af6812cca6984cffc19c3c52e7"
  end

  def name_version
    "fors-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "libcext"
  depends_on "telluriccorr"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
      update_workflows
    end
  end

  def update_workflows
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"

    replacements = {
      "CALIB_DATA_PATH_TO_REPLACE"  => (HOMEBREW_PREFIX/"share/esopipes/datastatic").to_s,
      "ROOT_DATA_PATH_TO_REPLACE"   => "$HOME/reflex_data",
      "$ROOT_DATA_DIR/reflex_input" => (HOMEBREW_PREFIX/"share/esopipes/datademo").to_s,
      "RAW_DATA_PATH_TO_REPLACE/"   => (HOMEBREW_PREFIX/"share/esopipes/datademo/fors").to_s,
    }

    workflow_dir_1.glob("*.xml").each do |workflow|
      replacements.each do |before, after|
        inreplace workflow, before, after, audit_result: false
      end

      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "fors_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page fors_dark")
  end
end
