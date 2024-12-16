class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19.tar.gz"
  sha256 "bb61983ba2c57b45f2d1ebd78f321e12badff824351ace4d4227fa97ead2bbe6"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19"
    sha256 cellar: :any,                 arm64_sequoia: "3eea74d28692be7d81acc5df6052b0d7a7298175d8bfadd7f1defd6bab4e550f"
    sha256 cellar: :any,                 arm64_sonoma:  "3bc81c3eb15379596827f264d4226517501654fbedcc6fff3e05686c1b2df5e3"
    sha256 cellar: :any,                 ventura:       "0382e94ecc9037b711d1ae29ce433883c8a4fe793fa70fd2e51784f97b9ce4bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b05ec77a581b666a89ab50913a0041ac374befab9a7b489bccf28d4ef66128c"
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
