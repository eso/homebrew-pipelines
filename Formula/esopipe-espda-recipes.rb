class EsopipeEspdaRecipes < Formula
  desc "ESO ESPRESSO-DAS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso-das/espda-kit-1.3.8.tar.gz"
  sha256 "d100d9c4318fcfd853f445413ee5a73ad8ca5f41f359ea016afae3758e7e33d6"
  license "GPL-2.0-or-later"
  revision 1

  def name_version
    "espda-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?espda-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-espda-recipes-1.3.8_1"
    sha256 cellar: :any,                 arm64_sequoia: "6ceb434459e1926375a08ffdf707f3f50671129b69141e6789d444953d45fede"
    sha256 cellar: :any,                 arm64_sonoma:  "acb7612d9138a22ac06f348bb7d97ff234d116024a3649320b50520b4b235153"
    sha256 cellar: :any,                 ventura:       "cd7d3e62296599a205f0298facd5fbd7f24f74341e62a94754b26f25bb1651a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee96e4c09debdaccc6b1dbacea0b11e56f2b5c1870d02d7a85274141242f326a"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure",
             "--prefix=#{prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}"
      system "make", "install"
    end
  end

  def post_install
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"
    workflow_dir_1.glob("*.xml").each do |workflow|
      ohai "Updating [ROOT|CALIB|RAW]_DATA_DIR in #{workflow}"
      inreplace workflow, "CALIB_DATA_PATH_TO_REPLACE", HOMEBREW_PREFIX/"share/esopipes/datastatic"
      inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      inreplace workflow, "$ROOT_DATA_DIR/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "espda_fit_line -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page espda_fit_line")
  end
end
