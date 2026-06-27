class EsopipeDetmonRecipes < Formula
  desc "ESO DETMON instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/detmon/detmon-kit-1.3.15-9.tar.gz"
  sha256 "71226a1b63ed65f3671f9e4fa753bac71adc8c11f22e16c23809eec859f4b98c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?detmon-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-detmon-recipes-1.3.15-9"
    sha256 cellar: :any, arm64_tahoe:   "9558038c76f458c197258f10913851c139665e301f5234f143c4b91fe5020026"
    sha256 cellar: :any, arm64_sequoia: "36eb3c45da9ee98074840b841c610fd3f6ba12d6fb47f4c009ce327465839481"
    sha256 cellar: :any, arm64_sonoma:  "59978f26b122ab843316e73420bc650defd5e03a5353c8b12ff0b4253944b081"
    sha256 cellar: :any, sonoma:        "3db89c19d29e12c59c6fdda3ddbebcb8b6a9cbf28ef0d3a018618aa936fd348e"
    sha256 cellar: :any, x86_64_linux:  "64f4a92d50c2940b34020b52329e7b207e5d5683b1ed089e77b9c721d7afe6fb"
  end

  def name_version
    "detmon-#{version.major_minor_patch}"
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
    assert_match "detmon_opt_lg -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page detmon_opt_lg")
  end
end
