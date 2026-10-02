class EsopipeMolecfitRecipes < Formula
  desc "ESO MOLECFIT instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.4.4-10.tar.gz"
  sha256 "ce539c12905ac7f8cd5537a9a56901843813b2055d4291c703f3140c5957092b"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?molecfit-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-molecfit-recipes-4.4.4-10_1"
    sha256 cellar: :any, arm64_tahoe:   "a5e8eced79308bfd20b804f16d9e3d39ea579ca5a9b4b8d146829b0b05e06974"
    sha256 cellar: :any, arm64_sequoia: "ef73df4dc9fef044eb7bfdd5f88fa787680ed06169d206f9f7eec704f6efcd28"
    sha256 cellar: :any, x86_64_linux:  "fe575630b644eb5a49ab7f85350ffbdb0652fb2d3a32e49d3eceb95f71c3598f"
  end

  def name_version
    "molecfit-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "esorex"
  depends_on "telluriccorr"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}"
      system "make", "install"
      update_workflows
    end
  end

  def update_workflows
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"

    workflow_dir_1.glob("*.xml").each do |workflow|
      inreplace workflow,
                "CALIB_DATA_PATH_TO_REPLACE",
                (HOMEBREW_PREFIX/"share/esopipes/datastatic").to_s

      inreplace workflow,
                "ROOT_DATA_PATH_TO_REPLACE",
                "$HOME/reflex_data"

      inreplace workflow,
                "RAW_DATA_PATH_TO_REPLACE",
                (HOMEBREW_PREFIX/"share/esopipes/datademo").to_s

      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "molecfit_model -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page molecfit_model")
  end
end
