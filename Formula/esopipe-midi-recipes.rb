class EsopipeMidiRecipes < Formula
  desc "ESO MIDI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/midi/midi-kit-2.9.6-6.tar.gz"
  sha256 "f9975ab72512196f8fdd65850af5714d3900c803f875064b76b8b79e2cd98fff"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?midi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-midi-recipes-2.9.6-6"
    sha256 arm64_sequoia: "bd6c48d51ca852533735e4ebdca1493a997f9e7686aef1c97a96c22d75d970d4"
    sha256 arm64_sonoma:  "d9c613d7da916a595e0f40c09c1e302eebc86af8c4d3e3435fab8b9c7315337d"
    sha256 ventura:       "617e6eeae32afa437f324e8b650d40f92cc4f8a970de2a5495c8781cac0f9027"
    sha256 x86_64_linux:  "e3b70272ac29fa2acdc72a8de68a83ec956cc8572f4ea883ca6c993051bed46f"
  end

  def name_version
    "midi-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl"
  depends_on "esorex"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}"
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
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE/reflex_input")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "midi_profile -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page midi_profile")
  end
end
