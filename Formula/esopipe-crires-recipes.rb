class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19-6.tar.gz"
  sha256 "48b996d430a528ab6515d5022e26c2a98b5235d4f0a1b1f84f04d47f19918fa3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-6"
    sha256 cellar: :any,                 arm64_sequoia: "8a0918e5f392519ed79d6ca6246f913c4422341bf00c33039098f767a3a55417"
    sha256 cellar: :any,                 arm64_sonoma:  "a8e73a14004374b69ba57a183b87fc3ee74096ff468ac128d035e19e2d350b19"
    sha256 cellar: :any,                 ventura:       "93efad2362dfb420f55c1bd4e3196d795fe882d6c7802ec69cf5c9de74be4c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f0963dacdb0a648807bc11822b7271594567bbad8dd1b92540903fe52f7495"
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
