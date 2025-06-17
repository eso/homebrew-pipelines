class EsopipeDetmonRecipes < Formula
  desc "ESO DETMON instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/detmon/detmon-kit-1.3.15-3.tar.gz"
  sha256 "d48c159ba8938dc692d51448367955d46db4cc404d2bca696627e959e182f35b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?detmon-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-detmon-recipes-1.3.15-3"
    sha256 cellar: :any,                 arm64_sequoia: "bf80e217ef4391ec5b3cfe94b7aa5ffa6a2de595bce0d891d92e56cd17328913"
    sha256 cellar: :any,                 arm64_sonoma:  "f686cce269ad5cd49b9e6f20690f577090f2438be8854fd8ac8f71e91506700b"
    sha256 cellar: :any,                 ventura:       "b7f6408158e5bdf334d7d461226a8f745c2e3f441eb43bacf6f8b55e24e1bd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c126ff9f4bfe85cbfca1a26349fc2130c258367f6754aa9e6bf78e7c5023893"
  end

  def name_version
    "detmon-#{version.major_minor_patch}"
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
    assert_match "detmon_opt_lg -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page detmon_opt_lg")
  end
end
