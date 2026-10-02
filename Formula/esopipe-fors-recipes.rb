class EsopipeForsRecipes < Formula
  desc "ESO FORS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/fors/fors-kit-5.8.7-2.tar.gz"
  sha256 "1636e7c61fe9833393834bc59802ba0cd4606ca9cba79f50b4faff1b1fea72f2"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?fors-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-fors-recipes-5.8.7-2_1"
    sha256 arm64_tahoe:   "f889f7a0fc5bd5ac2e061deed20c6f786106f88d11e3ad990f60a02c6f14efd2"
    sha256 arm64_sequoia: "43a775b38d9901f2712fb1ae1dedb16a562224028b8b6a039073ebd7869232ad"
    sha256 x86_64_linux:  "8850a61f8404ea7cd4c94727013bdab5aff71de8b085f850eefee177392da90d"
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
