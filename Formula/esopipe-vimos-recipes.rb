class EsopipeVimosRecipes < Formula
  desc "ESO VIMOS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/vimos/vimos-kit-4.1.14-2.tar.gz"
  sha256 "c7d687709638f7f722bcf5d0642ce139af6955d3ae029e99328b20da98e2b952"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?vimos-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-vimos-recipes-4.1.14-2"
    sha256 cellar: :any,                 arm64_tahoe:   "a5f6e72e5e4c705a7c1daba6ceeeb0c98f1f9b4490a4ff629b7db7692b373d8d"
    sha256 cellar: :any,                 arm64_sequoia: "5ce309a01645616c668da18b55f5f6f059988242bd4a7af6cee7084c2ca25629"
    sha256 cellar: :any,                 arm64_sonoma:  "c64701ff9e85631f4a9ea1d2d71c3558f69041c1d71aafc981d80b3cc54ba6d4"
    sha256 cellar: :any,                 sonoma:        "3fbfd7f470bdd98a9e962cda7467a9df444d69eb50f661ce8c872efdf0098787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "113d8bea5352db81216b60cbffa3014a47d93ce6a9bf92361d721cbff60a450d"
  end

  def name_version
    "vimos-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}"
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
    assert_match "vimos_ima_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page vimos_ima_dark")
  end
end
