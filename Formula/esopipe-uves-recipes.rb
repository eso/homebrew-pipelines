class EsopipeUvesRecipes < Formula
  desc "ESO UVES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/uves/uves-kit-6.5.3.tar.gz"
  sha256 "d1caf5474ad81d7c182b062e90badb4c9d7d11e0dd68233b10d216d83d5334d3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?uves-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-uves-recipes-6.5.2-1"
    sha256 cellar: :any,                 arm64_sequoia: "2e5f9669d1789d74d542b924ed75bbaa5e053ac392d7c99d2f18947d284a8efe"
    sha256 cellar: :any,                 arm64_sonoma:  "57dc8c887069e7563ce5df9b30b19f64e278999c5df3a81b911cc2764a15a356"
    sha256 cellar: :any,                 ventura:       "088b3cc56dd1034a791d9e6c109194d1441957ac868420d26cb01117829255d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a678ae74b5d24e1c3ac2a977e02127fd3f308f346b58459aefe2d867b93056fb"
  end

  def name_version
    "uves-#{version.major_minor_patch}"
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
    assert_match "uves_cal_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page uves_cal_mbias")
  end
end
