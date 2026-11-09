class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19-15.tar.gz"
  sha256 "0a3a191d7e8bc15c22f1c42d14359aa4318c2a79cf5450e8432cb85536e41699"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-15"
    sha256 cellar: :any, arm64_tahoe:   "0292706d434b179d7ce64457ff84f24443c2a8b30009b186000ce317ba422d2e"
    sha256 cellar: :any, arm64_sequoia: "c88f823bf0b205c1cb631ee81ce380d1d7803ecce46403b3d23664143b86f982"
    sha256 cellar: :any, x86_64_linux:  "08003115215f3f8ab510b1990addba1425158dda602b5903f6e0012bf5f25b21"
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
