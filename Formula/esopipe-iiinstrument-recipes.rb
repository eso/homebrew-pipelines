class EsopipeIiinstrumentRecipes < Formula
  desc "ESO example template instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/iiinstrument-kit-0.1.14-50.tar.gz"
  sha256 "b08f398d81afce30edc968ce8b5361051d2f545c28e3ec4690c1648e3ee1f134"
  license "GPL-2.0-or-later"
  revision 2

  def name_version
    "iiinstrument-#{version.major_minor_patch}"
  end

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/"
    regex(/href=.*?iiinstrument-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-iiinstrument-recipes-0.1.14-50_1"
    sha256 cellar: :any,                 arm64_sequoia: "20128aec1b94234386b8ee0a073fd09b8df103c0f881dbd4907ddb66770e8be9"
    sha256 cellar: :any,                 arm64_sonoma:  "2a9a7dad92a8e98415cc7c53985becb6ebf2d52a56aaa6ab281ecd4951da03a3"
    sha256 cellar: :any,                 ventura:       "97f05ed8c0c38f6e463246340ea63c42c0753f9b40f3d3c49fcf6a85b2b8fc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f21e98c67026794f20fbd46e0fe159f6b2ca1b79ba7b82ca95e1900ed951d27f"
  end

  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
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
    assert_match "rrrecipe -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page rrrecipe")
  end
end
