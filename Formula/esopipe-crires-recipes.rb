class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19.tar.gz"
  sha256 "bb61983ba2c57b45f2d1ebd78f321e12badff824351ace4d4227fa97ead2bbe6"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19_1"
    sha256 cellar: :any,                 arm64_sequoia: "0fe0c4c18383a1e4103074e8274334e13fcd1700b7184dcb350ae97ac4b8038b"
    sha256 cellar: :any,                 arm64_sonoma:  "66413811af58b815f7f0caca8d0157dbedd0fe7900b46b65d52b43e775d6ac64"
    sha256 cellar: :any,                 ventura:       "1068db4aad6f4e8a0315f00d6b59b72e6f1a3a5de339c79183ede99eedb12cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4682e546e9ef3a856c7f780a076c7b04f35a62b086fa5381ad0bfb6073412d41"
  end

  def name_version
    "crire-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "pkgconf" => :build
  depends_on "cpl"
  depends_on "esorex"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "crires_spec_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page crires_spec_dark")
  end
end
