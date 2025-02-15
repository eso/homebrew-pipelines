class EsopipeNacoRecipes < Formula
  desc "ESO NACO instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/naco/naco-kit-4.4.13-1.tar.gz"
  sha256 "999ed3bbd574f0821e0c00d8d51e41aff14c9ebf4cea586c642b8da5e048e383"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-naco-recipes-4.4.13-1_1"
    sha256 cellar: :any,                 arm64_sequoia: "62dd0240dc2e144c7b6896e3f3bf6f1f9b1b2a751c04c0655eba7b76735551e8"
    sha256 cellar: :any,                 arm64_sonoma:  "2dfa5ced8c6ea8b13f7ff89ebd9ad4f210c494a9dd3b72001bf4b86af10109f6"
    sha256 cellar: :any,                 ventura:       "9b28b44c92db51963fed164f040a07a0b497bfbe10b616ceb49fcb9b50a7f6f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32cbcb22633ad4a6a2ae05d40dc92bf701ceff599e9ff0d4ad17b84d3965a4af"
  end

  def name_version
    "naco-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?naco-kit-(\d+(?:[.-]\d+)+)\.t/i)
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
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
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
    assert_match "naco_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page naco_img_dark")
  end
end
