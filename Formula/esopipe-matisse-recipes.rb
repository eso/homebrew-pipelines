class EsopipeMatisseRecipes < Formula
  desc "ESO MATISSE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/matisse/matisse-kit-2.2.3-1.tar.gz"
  sha256 "7e636864a577b76b7bc9c68fab7fe02147c0c11ac75c0985c528453d76fabdbb"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?matisse-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-matisse-recipes-2.2.3-1_1"
    sha256 cellar: :any,                 arm64_tahoe:   "b31def6133e9815e437eb0fb2b560129f327bacb1a9a9e308c9f0356afcfd480"
    sha256 cellar: :any,                 arm64_sequoia: "81865d8683e4480c1faa15731f5b2e6522decf7a0a2be4c94fd0507659402553"
    sha256 cellar: :any,                 arm64_sonoma:  "5b8695c5cce8eb297a0aa85c8d64b0d318b75eb7895a0efc2f946d5441d84a93"
    sha256 cellar: :any,                 sonoma:        "bfdcb9f7e022b77e8bc61d99e8179ca03d91726b2bbce7954f8ae7bc72e206be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c623a22c2a4d72e14905aef72b9254b8e3a0112c29ae1dcc25cec6813b732d34"
  end

  def name_version
    "matisse-#{version.major_minor_patch}"
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
    assert_match "mat_wave_cal -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page mat_wave_cal")
  end
end
