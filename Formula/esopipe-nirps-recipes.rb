class EsopipeNirpsRecipes < Formula
  desc "ESO NIRPS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-kit-3.3.12-1.tar.gz"
  sha256 "5552ede0a3ddb6a5dd52f4fc347d6cc78f9beae378a53afd46bf9af2b2affc14"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?nirps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-nirps-recipes-3.3.12-1_1"
    sha256 arm64_tahoe:   "eee7d586b46fe3f3f3cbe73375fdf9a27136786e4cec0d63851158ce7ac39ecf"
    sha256 arm64_sequoia: "70e25b796a864482412da2bbcd5ad556fad99c7a6bab39e65179c1365ac0aee6"
    sha256 arm64_sonoma:  "d88b0c449278c15c3720957664abe11107629ac6d4cfab00f9ff765362c66e61"
    sha256 sonoma:        "281b7e3dd8e53a811a811306d2cf23e57631ee99482dcf856b59a93e86eaa6be"
    sha256 x86_64_linux:  "0fdd5e3b3320767fa1cd222f75f406f053104bde8533a5b3c28e50cf4154a492"
  end

  def name_version
    "nirps-#{version.major_minor_patch}"
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
    assert_match "espdr_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page espdr_mbias")
  end
end
