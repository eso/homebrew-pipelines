class EsopipeMolecfitRecipes < Formula
  desc "ESO MOLECFIT instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.3.3.tar.gz"
  sha256 "1b33df7da828d9be81fb54ad5251e236ffa8e53ceaa43c746a08b28ec8e84fc2"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-molecfit-recipes-4.3.3_3"
    sha256 cellar: :any,                 arm64_sequoia: "7d3fbcec7a029298aa8de9d33be00311dabd99d764169109b5a35461a4b49198"
    sha256 cellar: :any,                 arm64_sonoma:  "cc311a3dffc2bc4cf47fe49e10ae8a0e9de4c376cdf1d12f588333bff4627237"
    sha256 cellar: :any,                 ventura:       "0606d9b774c3b50505faf540b4d76307281e92fc3b102fa4e71c5ee54c381f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29234aa64b3dc88845671acd193e526ef306a6f031187cc936a26ea46b915449"
  end

  def name_version
    "molecfit-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?molecfit-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "pkgconf" => :build
  depends_on "cpl"
  depends_on "esorex"
  depends_on "telluriccorr"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}"
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
      if workflow.read.include?("RAW_DATA_PATH_TO_REPLACE")
        inreplace workflow, "RAW_DATA_PATH_TO_REPLACE", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "molecfit_model -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page molecfit_model")
  end
end
