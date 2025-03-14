class EsopipeVisirRecipes < Formula
  desc "ESO VISIR instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/visir/visir-kit-4.5.1.tar.gz"
  sha256 "3bbba703f01c0bb9752e1738e7727abf65e341ad2f1c9e42974e0e7f0182139c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?visir-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-visir-recipes-4.5.1"
    sha256 arm64_sequoia: "6f5e1ee014643ef03686e628f1bf68a59459a672ac26ab2a184de61157c5b467"
    sha256 arm64_sonoma:  "efc790cf4f1d444fa78ad6eca5b04a8b51959bbdcf5983eee4ee00c790c3a937"
    sha256 ventura:       "c4d08e37d15efc03bb3220d0273a1a6b10b23560a8b7354bae828d9c222c0d80"
    sha256 x86_64_linux:  "a4437089cb4579a0715dea674a093ca6b722072ca2d8d1b74bd11e7ddd6725a7"
  end

  def name_version
    "visir-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
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
