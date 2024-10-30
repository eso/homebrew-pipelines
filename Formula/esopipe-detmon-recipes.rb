# typed: strict
# frozen_string_literal: true

# Detmon
class EsopipeDetmonRecipes < Formula
  desc "ESO DETMON instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/detmon/detmon-kit-1.3.14.tar.gz"
  sha256 "4d7ea0eb8e082d741ebd074c53165d2b7b1868582bde57ab715833efd17f69f3"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?detmon-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/esopipe-detmon-recipes-1.3.14_1"
    sha256 cellar: :any,                 arm64_sonoma: "f962c7255f3b096ad2a813d589156a6333295e63268a3c08d57996f537c670b6"
    sha256 cellar: :any,                 ventura:      "a17f7a7f9b47e57e3fd271747b3af819db394df4a89da89e2b795f6368a85f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f68173e401f90fea71144735a50adc2e47eae2391578346df0815e4f7e5d8d8"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "curl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  def install
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    system "tar", "xf", "detmon-#{version_norevision}.tar.gz"
    cd "detmon-#{version_norevision}" do
      system "./configure",
             "--prefix=#{prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}",
             "--with-erfa=#{Formula["erfa"].prefix}",
             "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
    end
  end

  test do
    version_norevision = version.to_s[/(\d+(?:[.]\d+)+)/i, 1]
    assert_match "detmon_opt_lg -- version #{version_norevision}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page detmon_opt_lg")
  end
end
