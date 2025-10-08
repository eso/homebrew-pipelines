class EsopipeVcamRecipes < Formula
  desc "ESO VIRCAM instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/vircam/vcam-kit-2.3.15-8.tar.gz"
  sha256 "a6158029b151cce3972e64766bad178f6ed839d94cd07db82aa099f5fe6534ec"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?vcam-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-vcam-recipes-2.3.15-8_1"
    sha256 cellar: :any,                 arm64_tahoe:   "8e14e043bf92c2a4310ab230d1e456218a1c551bef66453c62ad6c77dc8daee3"
    sha256 cellar: :any,                 arm64_sequoia: "57370aec2108bd39fbb0c5d84b32e9029d8af4fd125726fb1896df6241d2a762"
    sha256 cellar: :any,                 arm64_sonoma:  "0e4cbe920297af8dd9796e8051d6edb60a5b9020835ba6d70e1902a311bacf9c"
    sha256 cellar: :any,                 sonoma:        "f3fec74e81caaeeddcd5412bba583c425b60c49f75cb5c5af7774afa41617369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c7dda9efc1d1a4baca96c68613b59157c5e9916d61d918e09ce3702da5fbc3"
  end

  def name_version
    "vcam-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}"
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
    assert_match "vircam_dark_combine -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page vircam_dark_combine")
  end
end
