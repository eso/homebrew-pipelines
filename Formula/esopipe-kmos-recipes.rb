class EsopipeKmosRecipes < Formula
  desc "ESO KMOS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/kmos/kmos-kit-4.5.3-6.tar.gz"
  sha256 "ce0797eb5624ed68535903691e0675ff84be612e48957020bcf40768ec9f67de"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?kmos-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-kmos-recipes-4.5.3-6_1"
    sha256 cellar: :any, arm64_tahoe:   "75b8147547e4b9cae5bc55fb2befd205205e11c5a4262bffab2c210017b82506"
    sha256 cellar: :any, arm64_sequoia: "5c02fa5d35b8de83691d65334d2c27ed18c4cf43d0c2cff3bf51445d9a489acc"
    sha256 cellar: :any, x86_64_linux:  "e03475050d9de5ef213ae01043abc20341008097f8d37f16cd48649b9c8f9790"
  end

  def name_version
    "kmos-#{version.major_minor_patch}"
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
      rm bin/"kmos_calib.py"
      rm bin/"kmos_verify.py"
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
                "$ROOT_DATA_DIR/reflex_input",
                (HOMEBREW_PREFIX/"share/esopipes/datademo").to_s

      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "kmos_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page kmos_dark")
  end
end
