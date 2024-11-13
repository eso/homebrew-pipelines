class EsopipeUvesRecipes < Formula
  desc "ESO UVES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/uves/uves-kit-6.4.6.tar.gz"
  sha256 "0d80c8cd55a271f2cb31549483ee139ac2e8054c759825d56bb605c41779a10a"
  license "GPL-2.0-or-later"
  revision 4

  def name_version
    "uves-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?uves-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-uves-recipes-6.4.6_3"
    sha256 cellar: :any,                 arm64_sequoia: "49b5e2ff0db8d12ffe10dd58e9711415edf8f351c71a382cbc7e20a906985b02"
    sha256 cellar: :any,                 arm64_sonoma:  "a91daf973e771115340d435a9cd8dc4fa613e6132adc16aac34d21a25d720e73"
    sha256 cellar: :any,                 ventura:       "156ae42200529172b3c3c132d3c23c0135572a9667f8d8e34c03d17eef8a8d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2fbf2980db6b5d70480c21b42ce0db16e9ecf71ebf9acc72245d8c3356cc511"
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
    assert_match "uves_cal_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page uves_cal_mbias")
  end
end
