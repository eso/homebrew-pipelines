class EsopipeForsRecipes < Formula
  desc "ESO FORS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/fors/fors-kit-5.8.5.tar.gz"
  sha256 "955b7f417edfd61af681af0cd53eee3a41e8b4c74e0a44df7cce8101a93efb2e"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?fors-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-fors-recipes-5.8.5_1"
    sha256 arm64_tahoe:   "c0b0dfcae4139174255f60119dc993c8dff5f912cef35264c7a4d96e6e111651"
    sha256 arm64_sequoia: "853099962ffa2483b5b1afacf4c1634530f3aa135a690f2e5664a153b60d5838"
    sha256 arm64_sonoma:  "3245831ac575686be561695800d43c65815e44cdcd3e5060199cbdd71d2e549e"
    sha256 sonoma:        "e5835878adaa760e2504983c9d8cb23bcb753572b83a2927355c68e11a53efc9"
    sha256 x86_64_linux:  "e134060e370dc5bfbf4df3709c05f84bd589f880a68a2a7828897c989b0dfee5"
  end

  def name_version
    "fors-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "telluriccorr"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}",
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
      if workflow.read.include?("RAW_DATA_PATH_TO_REPLACE/")
        inreplace workflow, "RAW_DATA_PATH_TO_REPLACE/", HOMEBREW_PREFIX/"share/esopipes/datademo/fors"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "fors_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page fors_dark")
  end
end
