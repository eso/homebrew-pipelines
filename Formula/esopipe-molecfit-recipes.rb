class EsopipeMolecfitRecipes < Formula
  desc "ESO MOLECFIT instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.3.3.tar.gz"
  sha256 "1b33df7da828d9be81fb54ad5251e236ffa8e53ceaa43c746a08b28ec8e84fc2"
  license "GPL-2.0-or-later"
  revision 1

  def name_version
    "molecfit-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?molecfit-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-molecfit-recipes-4.3.3_1"
    sha256 cellar: :any,                 arm64_sequoia: "89c4651ca670c6b9fb1c9b60ce9cb84f201e73ba1e49cf6a181e3193fbf6abf6"
    sha256 cellar: :any,                 arm64_sonoma:  "03d124a69901189b0e9c0295614184b89387ea0522c08c96568a41cf46ed083b"
    sha256 cellar: :any,                 ventura:       "5e063d9feac7df497e780e095c2bb9681f2bb84a807f332fa38b741f39f13cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17b6a29daca3953ff7ec8f6e2ca8d98597dcd37ea995af0edc8e0bcef9ab3d5c"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "telluriccorr"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-telluriccorr=#{Formula["telluriccorr"].prefix}"
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
    assert_match "molecfit_model -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page molecfit_model")
  end
end
