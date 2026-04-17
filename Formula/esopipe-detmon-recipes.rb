class EsopipeDetmonRecipes < Formula
  desc "ESO DETMON instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/detmon/detmon-kit-1.3.15-7.tar.gz"
  sha256 "68cb2b448e7bc193e70f86939b6d2c63c5dacf3ab2963984f1cf7514896426e9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?detmon-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-detmon-recipes-1.3.15-7"
    sha256 cellar: :any,                 arm64_tahoe:   "26adfda4c9a4ad26146adf3cebe627ccd7c724b5a203431c4047a6cd8cb314c8"
    sha256 cellar: :any,                 arm64_sequoia: "ee2d54ec42467813a1dc35ee02de552043f2c374faf7e5af6dda329089dcfa8c"
    sha256 cellar: :any,                 arm64_sonoma:  "7e96a027271ca39039c10f1258199438ca7d6a9acf9dcb839ef1a0709bade29d"
    sha256 cellar: :any,                 sonoma:        "6c9afebbd9572054871bd0020f1b130373f30cb3da85d0172d318b0165e28a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c391196618791a849f6fc859d82da7127e1540085bb28215194ea8b9ec5b20b3"
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
