class EsopipeMidiRecipes < Formula
  desc "ESO MIDI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/midi/midi-kit-2.9.6-7.tar.gz"
  sha256 "4a994689141bb3a0392f6ce7a1cc316d294beb01c2b48720711c090a88b37aee"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?midi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-midi-recipes-2.9.6-7_1"
    sha256 arm64_sequoia: "1ab25b1df72521c8e454d9c00fc2e7afc37bce7597ffbd387466437bb2360e74"
    sha256 arm64_sonoma:  "c29782d30b57b37164e0625d489d8f44699b5864f206d76e90d7cff058a64c9b"
    sha256 ventura:       "d8bc0d2d61da5d9e37013c8dcf587cb146fb1d1a665807f2903ec15c75387c95"
    sha256 x86_64_linux:  "584dc0e9d45f0df696d3d0f2caff300f374b065006bfade620b0020501f1661b"
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
