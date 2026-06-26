class EsopipeMidiRecipes < Formula
  desc "ESO MIDI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/midi/midi-kit-2.9.6-15.tar.gz"
  sha256 "9ebeab4df18fc74e7ca8b343599b21c5c325a1695198d1901a8c594deb00d30f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?midi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-midi-recipes-2.9.6-15"
    sha256 arm64_tahoe:   "04b8d7564d3ff2c3afe83dd9cec714dd172416b5b3d47bfa1f7487cc6b49b10a"
    sha256 arm64_sequoia: "b2b0f127dfc15775df26aa24c6366aed6b5c102c0a47fdcb40509369395e821a"
    sha256 arm64_sonoma:  "b49f199a13383b05edc27f2f375cb4576aa1ee4801279fd92f4c38b4e4bb5127"
    sha256 sonoma:        "82abc2fd72519bc552779fd52507f794a887822b39f608f4f81ad384b5825a29"
    sha256 x86_64_linux:  "4483e071330c1b21e7805a9c2a61cc81043cea836e812596b23b8d2b81b7e34f"
  end

  def name_version
    "midi-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.4"
  depends_on "esorex"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}"
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
