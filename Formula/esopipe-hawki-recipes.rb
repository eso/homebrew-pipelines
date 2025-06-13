class EsopipeHawkiRecipes < Formula
  desc "ESO HAWKI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/hawki/hawki-kit-2.5.11.tar.gz"
  sha256 "b09d8984c87f838f0cfb8a93abef53ebe1cd6b95e20fdc93af6474aae91950b1"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?hawki-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-hawki-recipes-2.5.11_1"
    sha256 cellar: :any,                 arm64_sequoia: "7c6a24f9ecea16ba1af4097182ad1272d1bea05d34fe401be395f53e063d16ab"
    sha256 cellar: :any,                 arm64_sonoma:  "312a2084a96e1fb46e58a7ce4440abcb6306fd50915bfbef3ae67b13c0f4fa25"
    sha256 cellar: :any,                 ventura:       "f75bfdfffdce19e3c3d28c79bf4a8cbd713f6ce989b682f355ca15df14fde6fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7af53a7bb3579b9d37a538154f3bf6f62dc76ffbfd808bcc838e396eadc5b193"
  end

  def name_version
    "hawki-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl"
  depends_on "esorex"
  depends_on "gsl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
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
    assert_match "hawki_cal_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page hawki_cal_dark")
  end
end
