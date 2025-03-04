class EsopipeMolecfitRecipes < Formula
  desc "ESO MOLECFIT instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.3.3-6.tar.gz"
  sha256 "cbb6eea020fb5e350afd3f506c079e8632ee94c531859eee7e57dedf8b4705f4"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?molecfit-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-molecfit-recipes-4.3.3-5"
    sha256 cellar: :any,                 arm64_sequoia: "2924b15d228982b622eeced4bfedc969c92319a9596aa6ce929179a31c223a15"
    sha256 cellar: :any,                 arm64_sonoma:  "9e31dcb5acd63e0bdc8db70acc806833466ef0165613d08a4664c0d1d4710176"
    sha256 cellar: :any,                 ventura:       "b744c4772f1b94a89a6cdee8cc6bfd9e8af6553c2f351f1478c64b7009b0c80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9372e11a869512c0707e2c14957ed81b3880fcd48ef4443aeeb32f2866eb2e25"
  end

  def name_version
    "molecfit-#{version.major_minor_patch}"
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
