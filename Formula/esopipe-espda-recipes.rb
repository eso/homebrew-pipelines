class EsopipeEspdaRecipes < Formula
  desc "ESO ESPRESSO-DAS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso-das/espda-kit-1.4.0-3.tar.gz"
  sha256 "7b4a07376cc9c4660fac012bdfea1b04915d8873608a9a7180b5a54dadaac9c5"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?espda-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-espda-recipes-1.4.0-3_2"
    sha256 cellar: :any,                 arm64_sequoia: "cfe4f544879d19e8e4754c6154145e9379938a6f1545f2d27018c5fd870b207a"
    sha256 cellar: :any,                 arm64_sonoma:  "58e544c54122659430d612f42df007c4b3b97aabbab1aa690884eef0487bd236"
    sha256 cellar: :any,                 ventura:       "30128cc36a849f415ad245b4cb7ceef50e493c04f7aec1d4f4b3b1209d83a208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67294a892e6cf66c66557d2ed781771d668ae0540ae4bac1f03fae70531f913f"
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
