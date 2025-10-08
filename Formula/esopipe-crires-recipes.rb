class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19-8.tar.gz"
  sha256 "c8e1c85360485c692090bb7e040d19ccc47de3bcd931fb7a5531c51293e8bcce"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-8_1"
    sha256 cellar: :any,                 arm64_tahoe:   "2fc95bff6bd60f848072d68bc400ada0853b32b8c0014019ebdf332da7872da5"
    sha256 cellar: :any,                 arm64_sequoia: "3b5f1a193e53147ae98e08cb751ef7845cdfbc10b1efb6c9abbaecd14af19898"
    sha256 cellar: :any,                 arm64_sonoma:  "db6df65345bfd4d1ba5f671507eedc239a8dfcbc818847f8b73659d93c5eec2a"
    sha256 cellar: :any,                 sonoma:        "96264c9d5e0263cfc9a9d88926e84bc167cde797551e08f7e0216366924d8252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2299bef478495a729c7e8aa8ee93fb76950d37bceab21e25732ac95710533d09"
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
