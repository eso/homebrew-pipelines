class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19-7.tar.gz"
  sha256 "af479a8a52eddd10b5e343d87003ac9f2ebaca0aa705b880e02f8aeea281bd4d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-6_2"
    sha256 cellar: :any,                 arm64_sequoia: "0ef3623118718117529f854c8342c5857a02248435e77e14cc4c59cffc10ca66"
    sha256 cellar: :any,                 arm64_sonoma:  "5c966230d2a6ada8a31fd55fce5aa9590b5eff461b68a1468a41d15eba7fff13"
    sha256 cellar: :any,                 ventura:       "34fcebcbb0f6f462cc65e78430c3c6684b486659a4c7024eb0070934ca45ac83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc6dc886c990df00a5a25aeb31cd9a3b804d809deffc2e6d4d9ea2898b44715c"
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
