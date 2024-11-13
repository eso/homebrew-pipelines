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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-detmon-recipes-1.3.14_2"
    sha256 cellar: :any,                 arm64_sequoia: "0919ed520ea70bce62bb8a9c95d495abfa0188ef86d163573471ea324a33be71"
    sha256 cellar: :any,                 arm64_sonoma:  "5ad6ce0843b0c47b584b519e41dee0dc10b91c2e220c577f335e930c0ff1d333"
    sha256 cellar: :any,                 ventura:       "b04cac730c438b70af10d688db590f434908934ccd69196b70648890ff80be05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49da6e66c2b75f0684391d0085e391c30c2e6b3f1771493b0ba87101cd5076e8"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  uses_from_macos "curl"

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
