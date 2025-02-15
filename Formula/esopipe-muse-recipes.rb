class EsopipeMuseRecipes < Formula
  desc "ESO MUSE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/muse/muse-kit-2.10.10.tar.gz"
  sha256 "d3d51e755a0fdffc21d5730e0041f4e3a4826ec9ffcb97c1f0f69860a7a693df"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-muse-recipes-2.10.10_4"
    sha256 cellar: :any,                 arm64_sequoia: "fb20e5b9676bd5ed35bd77a2e82b5996956d991dadb7ad868ff87a9396c77f3e"
    sha256 cellar: :any,                 arm64_sonoma:  "cd505b31f746025dfa313b145d049a3b3193ecc623a679db545d1132cba59acd"
    sha256 cellar: :any,                 ventura:       "2384e9bc51dd3a0786828d6e169d3fdda46a2d8dabb8fa47e15535640087037e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0976aa229d8bf9e045a9bdb68b2bee640321e1fa8a5a77ca05b883972906d45c"
  end

  def name_version
    "muse-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?muse-kit-(\d+(?:[.-]\d+)+)\.t/i)
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
    assert_match "muse_bias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page muse_bias")
  end
end
