class EsopipeMidi < Formula
  desc "ESO MIDI instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/midi/midi-kit-2.9.6-15.tar.gz"
  sha256 "9ebeab4df18fc74e7ca8b343599b21c5c325a1695198d1901a8c594deb00d30f"
  license "GPL-2.0-or-later"

  def pipeline
    "midi"
  end

  livecheck do
    url :homepage
    regex(/href=.*?midi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "esopipe-midi-recipes"

  def install
    system "tar", "xf", "#{pipeline}-calib-#{version.major_minor_patch}.tar.gz"
    (prefix/"share/esopipes/datastatic/#{pipeline}-#{version.major_minor_patch}").install Dir["#{pipeline}-calib-#{version.major_minor_patch}/cal/*"]
  end

  test do
    system "true"
  end
end
