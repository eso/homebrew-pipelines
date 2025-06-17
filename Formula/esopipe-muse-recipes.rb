class EsopipeMuseRecipes < Formula
  desc "ESO MUSE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/muse/muse-kit-2.10.14-2.tar.gz"
  sha256 "28a6c39c6837fb7b31f22f90414260983ed1c7a4ffa402953788aad63dc33a65"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?muse-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-muse-recipes-2.10.14-1_2"
    sha256 cellar: :any,                 arm64_sequoia: "b98ccb43914f2868216bfb78ffdb0e9ae8d97c2541ace81bf141d1e4c35cba3d"
    sha256 cellar: :any,                 arm64_sonoma:  "bcf1f5c0807150a7dbb1bc1343c455a70c6267a8d9eecc7eb765c677139380f6"
    sha256 cellar: :any,                 ventura:       "5a1a5d3c14c73b11f06beeca39607e09c1e5f20debb3a5b761e12a65c6de31cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59074bdca3570ce5dd98d5c6c33732c31bd2d7c60c8a4ae856c517244f376565"
  end

  def name_version
    "muse-#{version.major_minor_patch}"
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
    assert_match "muse_bias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page muse_bias")
  end
end
