class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19-6.tar.gz"
  sha256 "48b996d430a528ab6515d5022e26c2a98b5235d4f0a1b1f84f04d47f19918fa3"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-6_1"
    sha256 cellar: :any,                 arm64_sequoia: "b204593050f63b26bb126a29c81fbe06482739983f0644b396e619e6b8791a7d"
    sha256 cellar: :any,                 arm64_sonoma:  "90bfe055758d5a6a9f13ae93ad62d2330a7dda29689636b9ff3150cf5a277e5c"
    sha256 cellar: :any,                 ventura:       "ede2ac2dc4d9d387101121c97d65cdb3f2ab130ba0e046923ffefc528a5c5ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7807b2a737520c4153c34e07e6e5ce4f74324aa9a71383b53452bea7fc90f4c0"
  end

  def name_version
    "crire-#{version.major_minor_patch}"
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
