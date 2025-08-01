class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19-8.tar.gz"
  sha256 "c8e1c85360485c692090bb7e040d19ccc47de3bcd931fb7a5531c51293e8bcce"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-7"
    sha256 cellar: :any,                 arm64_sequoia: "fc79a88ab1bbcf3301214eaa121376b91689ea8a515f746f1a65bbe290714acc"
    sha256 cellar: :any,                 arm64_sonoma:  "4c73db05abcb262a47071516f34940fa6f9aea450f0f062c68cdfe7b72ef4e62"
    sha256 cellar: :any,                 ventura:       "4ea8b8686c02ef26a89d018d04e54bbdebf9f4f442424d3f56dcbbe27707ee34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4e0bb7c2fe9a88b405661c478809dbee368f3460f8165be29982eb1064d1ae9"
  end

  def name_version
    "crire-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "crires_spec_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page crires_spec_dark")
  end
end
