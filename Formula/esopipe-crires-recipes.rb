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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-8"
    sha256 cellar: :any,                 arm64_sequoia: "ece97ac70b836b2df483bd5b519f762810f361641e926250ded9a5a5184dbb46"
    sha256 cellar: :any,                 arm64_sonoma:  "7c23f4dcc8a9237c000d4c89f4afb411b57d842af5595c8318d9ecaa6d8b127e"
    sha256 cellar: :any,                 ventura:       "1acdac76845e957d13a481ec7fe2f3d00fcee255732ecb380e0a715097ad0a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c20fb1cbc48257ab8cde25967059205f0eea4323c9d38ac471d8d9ba920d335"
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
