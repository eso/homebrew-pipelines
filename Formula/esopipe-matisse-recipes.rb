class EsopipeMatisseRecipes < Formula
  desc "ESO MATISSE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/matisse/matisse-kit-3.0.0.tar.gz"
  sha256 "4381f518b3b564c4b7485e037d9ecfd1237f2cbf3dc46fd956469aa082f39620"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?matisse-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-matisse-recipes-3.0.0"
    sha256 cellar: :any, arm64_golden_gate: "2122e17d9ecb1e57bd4e4c225bbc68f96afde9d6ee3e66bae53be2975e1d49e5"
    sha256 cellar: :any, arm64_tahoe:       "b907913eac44e18f63d5e869e82cf56b3c0a8856a7f86e951b309f43c4f14e43"
    sha256 cellar: :any, arm64_sequoia:     "ef01cffc1625dbf5e434f640d3a4d801d2a18f1cc6f332a8a8e10964fe89d9a0"
    sha256 cellar: :any, x86_64_linux:      "1216040b89bd5fc2622f79614aba8273688359c06cc4ff3569fd159075edaafa"
  end

  def name_version
    "matisse-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "libcext"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
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
                "$ROOT_DATA_DIR/reflex_input",
                (HOMEBREW_PREFIX/"share/esopipes/datademo").to_s

      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "mat_wave_cal -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page mat_wave_cal")
  end
end
