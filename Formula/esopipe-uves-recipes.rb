class EsopipeUvesRecipes < Formula
  desc "ESO UVES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/uves/uves-kit-6.5.2.tar.gz"
  sha256 "54c4dc61f257d0049ffb016b64c50900795315ff8082d78f1915e377a352c8ad"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?uves-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-uves-recipes-6.5.2_2"
    sha256 cellar: :any,                 arm64_sequoia: "c644d36cb5fabb335fb4a7b05827d93a5e436eb0a636a381202ec56dcd7f26b0"
    sha256 cellar: :any,                 arm64_sonoma:  "3fe4bc93a0ba75bbaee3829c84fdc0f44d6c68becc2d9af74760a8c51e414244"
    sha256 cellar: :any,                 ventura:       "71f2ee8ce6c875abc716d349a4c621904333cef2e39c0317a4b5f5f429b9e0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a0085fccab7644ec6956f355168570a548fb9c3d745aac0920acc42904fef3f"
  end

  def name_version
    "uves-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
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
      if workflow.read.include?("$ROOT_DATA_DIR/reflex_input")
        inreplace workflow, "$ROOT_DATA_DIR/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "uves_cal_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page uves_cal_mbias")
  end
end
