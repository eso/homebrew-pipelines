class EsopipeMolecfitRecipes < Formula
  desc "ESO MOLECFIT instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.4.4-10.tar.gz"
  sha256 "ce539c12905ac7f8cd5537a9a56901843813b2055d4291c703f3140c5957092b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?molecfit-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-molecfit-recipes-4.4.4-9"
    sha256 cellar: :any, arm64_tahoe:   "1434da4509927a79c2798a6ad0280900639058c50f66cca488ec6e71960dd71c"
    sha256 cellar: :any, arm64_sequoia: "eca68581a1e6691eb5c9181d2a88ea2ada0f238063c3add63238c2e0579e32a8"
    sha256 cellar: :any, arm64_sonoma:  "bfad56d64f8d61aa06fdbb6014e951cf4a9350c90411f1dfe3c2843abe7c2526"
    sha256 cellar: :any, sonoma:        "0567f66a0778a27bcd65ce71bc91a9c441e3e06ae6406257abe633e82e621f71"
    sha256 cellar: :any, x86_64_linux:  "96e382fefb3a04481759b4edb4851d49113c02ef2d7c234961989192c4b2a6df"
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
