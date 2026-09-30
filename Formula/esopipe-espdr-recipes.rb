class EsopipeEspdrRecipes < Formula
  desc "ESO ESPRESSO instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso/espdr-kit-3.6.0.tar.gz"
  sha256 "af577157f742790a121e02e3d0ba44330c4ab6bcc26545cc74fa4c61503ec9b7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?espdr-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-espdr-recipes-3.6.0"
    sha256 arm64_tahoe:   "1e25be51c59709ec0603aa95e0874f7bf7182eb165ec0a811907b8ac08c7d834"
    sha256 arm64_sequoia: "e99caa6350024bb8eb7f3412e7c8109e52619eab1d58cac2e603a814e0a0105f"
    sha256 arm64_sonoma:  "0b68a3ecbff7cb91fe2bbba478a24826078c5d5f15fa10ca739490c16b35ebac"
    sha256 sonoma:        "1cbaf695692eadcaa6911c17335fa72e48b3d7120212ad7d78fd035d81068ac5"
    sha256 x86_64_linux:  "56c86e85fa4fb7595f90912da339b4ac1081dfbf2c1290296fdeb8081afd70ac"
  end

  def name_version
    "espdr-#{version.major_minor_patch}"
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
    assert_match "espdr_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page espdr_mbias")
  end
end
