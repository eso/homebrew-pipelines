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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-5"
    sha256 cellar: :any,                 arm64_sequoia: "711133fa656d43e521738dc9c235f2d82123399d27afcd21f20df4e5b46a6ffc"
    sha256 cellar: :any,                 arm64_sonoma:  "2b11d0a19600715f3b7c37c7f8b5bcaee63cd78859e6e8361a2602b690eb4df3"
    sha256 cellar: :any,                 ventura:       "0d63461b33bc19749ce55e50eded5c02d1059c1f00a590e8cbbaf15135cc49c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f9ba0fa9849ffce6b5455fb76c5f763f2771bf06ed36ddc2c8c4d165ae506e3"
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
