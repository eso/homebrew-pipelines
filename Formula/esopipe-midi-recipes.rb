class EsopipeMidiRecipes < Formula
  desc "ESO MIDI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/midi/midi-kit-2.9.6-12.tar.gz"
  sha256 "41efeafab116d7f0ff7920e3106a2c7aef8ddefe5a908f5d7326ba233b884d0e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?midi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-midi-recipes-2.9.6-12"
    sha256 arm64_tahoe:   "a9218383d73aa857701c1d4b926449ecf12981bd480948fc70a3b605d14ba26a"
    sha256 arm64_sequoia: "0d7085f51ddfb4b9e80862ffb11541eda25f7c35c2c63717c9fe4d1a9522922d"
    sha256 arm64_sonoma:  "6cb89c95de21d620d28694f4c33e96b89152b3e7bad001d7c36e51cca33e58da"
    sha256 sonoma:        "655501c7056c54e226f8b241c02f1f7c79889eae52bc641567f55f5f43f91f6b"
    sha256 x86_64_linux:  "f3c641119ac59f8b3ac7eb6d337e2b2b28a456e0a6eba96a692789631ae7cd59"
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
