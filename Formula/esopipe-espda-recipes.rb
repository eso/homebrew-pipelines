class EsopipeEspdaRecipes < Formula
  desc "ESO ESPRESSO-DAS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso-das/espda-kit-1.4.0-7.tar.gz"
  sha256 "0ebe856f384738491b63553166aed0a348d1b6abcc5276f2dcd70420197ef1ca"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?espda-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-espda-recipes-1.4.0-7"
    sha256 cellar: :any,                 arm64_tahoe:   "83b86c5f79c38bbed405a697fca06f0b5dd360ed0f2da467cae734a1bacd3c43"
    sha256 cellar: :any,                 arm64_sequoia: "9318e2f16ca77f1d1edc05113f6b489df4681f2208553163ae1a7178f3ee9e1c"
    sha256 cellar: :any,                 arm64_sonoma:  "dfd9056aa51bd5e9fbe6ab51935c286d16115a2305e185f1e463bbfcbf8a39d5"
    sha256 cellar: :any,                 sonoma:        "2dcd76456b96ca842ffd96d98b9d2f09eaa3da621bd8d1eab29b9ca99c03c33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e286376baf81e613629d5b09c501010d128918acc5db4d701a21638dc1526f11"
  end

  def name_version
    "espda-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "gsl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
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
    assert_match "espda_fit_line -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page espda_fit_line")
  end
end
