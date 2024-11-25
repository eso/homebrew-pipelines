class EsopipeEris < Formula
  desc "ESO ERIS instrument pipeline (static data)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/eris/eris-kit-1.7.0.tar.gz"
  sha256 "66b7e71f7c27112622dcfba4734b0a1cc06a35c26728ee723c99618990c2281a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?eris-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-eris-1.7.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bbd3cbe593e626ff2bd811c77087c0acd7fd71beb42beaf3782e2b9108ac829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e70d8b284d96f03e9b26017ed56bc35934fdea126880231bf4412564b078af3"
    sha256 cellar: :any_skip_relocation, ventura:       "6490c91d79ba83b232bab9d20e41cd610ddabcc0501a37ba8c42b9dee324bbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28a5b5db21bdd295ce93061be9a50ab515a5211be51a039f5d4c070a9c12f56d"
  end

  depends_on "esopipe-eris-recipes"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "eris-calib-#{version_norevision}.tar.gz"
    (prefix/"share/esopipes/datastatic/eris-#{version_norevision}").install Dir["eris-calib-#{version_norevision}/cal/*"]
  end

  test do
    system "true"
  end
end
