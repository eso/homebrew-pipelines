class EsopipeEspdaRecipes < Formula
  desc "ESO ESPRESSO-DAS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso-das/espda-kit-1.4.0-8.tar.gz"
  sha256 "7b887222570f4e86bdb8cb6d2f416dbb42209cf7fcd94885ce7c8fd983a6b021"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?espda-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-espda-recipes-1.4.0-8"
    sha256 cellar: :any, arm64_tahoe:   "251ca9cdfa8bb6700e3dfbe4228378e18e8e3beb20825d0a4c5a4d592dc99913"
    sha256 cellar: :any, arm64_sequoia: "7ca1872544ae0e39cfef18448851cb851dca55ebe3e59f7f89dc6b4707f3e867"
    sha256 cellar: :any, arm64_sonoma:  "bc77c223546407dd5a8169a77b725e7c6e51ef5c8eaa46eee1e3be5ce7d5164c"
    sha256 cellar: :any, sonoma:        "3c2ec98303feed155a8964d0acde82d2491c59c22139dcbb145a998dcbd8e6e0"
    sha256 cellar: :any, x86_64_linux:  "8cf86dde3659af6aa31bff5226d4c15c2b127c72c120cbb737a7e72c252cd00d"
  end

  def name_version
    "espda-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "esorex"
  depends_on "gsl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
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
