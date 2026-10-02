class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19-14.tar.gz"
  sha256 "4fcbee1c62ee6f57ed852aeb1dcabc7ed4ccb1ba6a3f7478d74ad10f037fd7fd"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-14_1"
    sha256 cellar: :any, arm64_tahoe:   "495ddfbccfba12e975f38c8c2504038646ef806be13d77d10763af020f7e8da3"
    sha256 cellar: :any, arm64_sequoia: "c6f202e55efa2cbf85a6fb70bdf1e920a89eacbc9869ca4cebb0b5a0700ea3de"
    sha256 cellar: :any, x86_64_linux:  "4752f1102780e60e04ee6722051cad7b8576da7acd35cbcae081fb143002420c"
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
