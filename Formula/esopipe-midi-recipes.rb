class EsopipeMidiRecipes < Formula
  desc "ESO MIDI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/midi/midi-kit-2.9.6-8.tar.gz"
  sha256 "72f5dc5654dc64853b1adde8f6d85689f207ec40457b07d77526b603829be4cb"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?midi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-midi-recipes-2.9.6-8"
    sha256 arm64_sequoia: "f8d5af51da211bf58071ae08ec1342a0ad5763f6c2abdf0cb2ed878b0c5e0589"
    sha256 arm64_sonoma:  "de73847dee12272e4d9dadafb72c9d479f70c83eca8536a7db89fb5b77239339"
    sha256 ventura:       "6479bb749f36f0b8d94f518d4095144b4faeeff8c2099856fb59c1bfe5d8a96e"
    sha256 x86_64_linux:  "519910be7fa5deec6e571cabcab22a025b4fbf63db19656d6ccca5452916dd2a"
  end

  def name_version
    "midi-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "esorex"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
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
