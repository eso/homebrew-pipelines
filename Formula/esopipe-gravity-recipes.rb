class EsopipeGravityRecipes < Formula
  desc "ESO GRAVITY instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/gravity-kit-1.7.0-1.tar.gz"
  sha256 "2f3c9025e21f2410166517e613ce8c78f78e3c80ed697661ff2b7fcd688eefc2"
  license "GPL-2.0-or-later"
  revision 2

  def name_version
    "gravity-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?gravity-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-gravity-recipes-1.7.0-1_1"
    sha256 cellar: :any,                 arm64_sequoia: "0dbef9782d0f9b62d4cdc36f5a84245e4285e405048cd504514a9fb0568ba8c7"
    sha256 cellar: :any,                 arm64_sonoma:  "1d8e3a2f9683fa6886156d30a48bcd3074f5c812d1ab0b8d07769ce03f251e7b"
    sha256 cellar: :any,                 ventura:       "b6f4046f196c90456f6542abacace0069039946ee8e99b25a50dcfc2db1ef2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "468806cc36e71289d57ea0604a44d67c3976f6059aa505d76b9773322280b5b4"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-gsl=#{Formula["gsl@2.6"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
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
    assert_match "gravity_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page gravity_dark")
  end
end
