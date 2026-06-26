class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19-14.tar.gz"
  sha256 "4fcbee1c62ee6f57ed852aeb1dcabc7ed4ccb1ba6a3f7478d74ad10f037fd7fd"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-14"
    sha256 cellar: :any, arm64_tahoe:   "1632af9030284da28dda9709676b19ad5a0aeb7431fe30f8d816d02c7946af47"
    sha256 cellar: :any, arm64_sequoia: "53c129f55f357f3468855f44f54d3caecb81e8d14fb38413c5d35255f3327640"
    sha256 cellar: :any, arm64_sonoma:  "7684e26d2df0a7e7adb71e1c3d86dfe70cb3caadf75e8e4d64cdf25df924d50f"
    sha256 cellar: :any, sonoma:        "287699b188ee6331f3028e1a3b9041abe5c4cc71329f0de65fc7d07912baa4d7"
    sha256 cellar: :any, x86_64_linux:  "1d9b8314658d4ca5c68847e2c798e3672eadde19b0b0acfc011ebb2b6343cce4"
  end

  def name_version
    "crire-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "esorex"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "crires_spec_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page crires_spec_dark")
  end
end
