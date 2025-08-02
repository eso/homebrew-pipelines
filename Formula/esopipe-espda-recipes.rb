class EsopipeEspdaRecipes < Formula
  desc "ESO ESPRESSO-DAS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso-das/espda-kit-1.4.0-5.tar.gz"
  sha256 "e09066a5c71ceb8854e41b321fae2ff677cfa7462c45514e200a433338d3b44a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?espda-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-espda-recipes-1.4.0-5"
    sha256 cellar: :any,                 arm64_sequoia: "5e144e1f127d32d1c6b379d56572b23c365851c3fc25b3ef8a4a1b67d577636b"
    sha256 cellar: :any,                 arm64_sonoma:  "348ac55ea5e1fd7ec63fa120c469f199f3a8fe00387190508e19dcbfddf4bca0"
    sha256 cellar: :any,                 ventura:       "1122198a0d8af8ad05d79c88c901e585d16ea2fcc0758cfce9d36071e546e178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f93504b799e79875da31c8033c6b1942e64a300cc410702d92ea0f3fba27d251"
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
