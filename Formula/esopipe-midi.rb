class EsopipeMidi < Formula
  desc "ESO MIDI instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/midi/midi-kit-2.9.6-8.tar.gz"
  sha256 "72f5dc5654dc64853b1adde8f6d85689f207ec40457b07d77526b603829be4cb"
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
