class EsopipeVisirRecipes < Formula
  desc "ESO VISIR instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/visir/visir-kit-4.4.5.tar.gz"
  sha256 "8833896bfc1e85e60a3a7d24c015d2ec5ca81807e908a0ca5a70970347d1aaa0"
  license "GPL-2.0-or-later"
  revision 2

  def name_version
    "visir-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?visir-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-visir-recipes-4.4.5_2"
    sha256 arm64_sequoia: "9df11f4ffac5f81cee2001d138240bdf7e45d3b03d9b39763362b97177160a6f"
    sha256 arm64_sonoma:  "0636300a1d6e8bd34e145eab5bed01422a51283f0034c7d905a3328636c2a254"
    sha256 ventura:       "0cf2fb87f355858423f02e295299d1396729de2786cca5b01fa892da0f7bfb63"
    sha256 x86_64_linux:  "215be18bb3c1bb9860ad6c1ce95b27310e11a0e7885da43afec49606d0aeff69"
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
    assert_match "visir_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page visir_img_dark")
  end
end
