class EsopipeHawkiRecipes < Formula
  desc "ESO HAWKI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/hawki/hawki-kit-2.5.8.tar.gz"
  sha256 "8c5640b1ea05d790ab708169c303fa43a143002b295a3b870c4300d49cd6ff5c"
  license "GPL-2.0-or-later"
  revision 3

  def name_version
    "hawki-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?hawki-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-hawki-recipes-2.5.8_3"
    sha256 cellar: :any,                 arm64_sequoia: "8a9f51edc5949ca6b804ea07f83ed280a665765e1fb15a04436b6aa8b72d364e"
    sha256 cellar: :any,                 arm64_sonoma:  "cb233d3a53c8ab683cddd2eca2cdaaefd2a6358f56e1b0b3b35557e249592ff5"
    sha256 cellar: :any,                 ventura:       "2bfd3b3ca24e6b2664a39a24ab2c6e56e4475450a0979c6bd3246a2179dda53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f097facc7cd17da7e8308716a6f7efcfccf0e43097a2256cc29798dfce14c6"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-gsl=#{Formula["gsl@2.6"].prefix}"
      system "make", "install"
    end
  end

  def post_install
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"
    workflow_dir_1.glob("*.xml").each do |workflow|
      ohai "Updating [ROOT|CALIB|RAW]_DATA_DIR in #{workflow}"
      inreplace workflow, "CALIB_DATA_PATH_TO_REPLACE", HOMEBREW_PREFIX/"share/esopipes/datastatic"
      inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      inreplace workflow, "$ROOT_DATA_DIR/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "hawki_cal_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page hawki_cal_dark")
  end
end
