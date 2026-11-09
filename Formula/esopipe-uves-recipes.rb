class EsopipeUvesRecipes < Formula
  desc "ESO UVES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/uves/uves-kit-6.5.3-7.tar.gz"
  sha256 "d98bf67ce3b83df332231f557516360d886bf4e99ba568182c7bd10ad6c6a312"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?uves-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-uves-recipes-6.5.3-7"
    sha256 cellar: :any, arm64_tahoe:   "d6f7d3dc4fdaf127b61ce707b492470b847eb1f270f7968c93f87c4f56f11378"
    sha256 cellar: :any, arm64_sequoia: "74a9000c12e059f5e5637b55ba2a3dabd0b51e54c840ef7423b3e4412379c2b2"
    sha256 cellar: :any, x86_64_linux:  "f61a78df018bf0e2f25bb0ec06edef40f5c0bf0bb8689d36063874b7361bf9c9"
  end

  def name_version
    "uves-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
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
    assert_match "uves_cal_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page uves_cal_mbias")
  end
end
