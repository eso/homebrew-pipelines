# typed: strict
# frozen_string_literal: true

## Datastatic
class EsopipeXshooterDatastatic < Formula
  desc "ESO XSHOOTER recipe plugins (Calibration Data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/xshooter/xshoo-kit-3.6.8.tar.gz"
  sha256 "e50f7172d65de8b8f54fc47a333d49a5fa6db34aabe097bbc1a3449f455ab2b9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?xshoo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "xshoo-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/xshoo-#{version_norevision}").install Dir["xshoo-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
