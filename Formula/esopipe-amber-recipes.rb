class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-8.tar.gz"
  sha256 "b2a8576ba2fc8ca620b39db7f4ca652375276a10a984183668e5d8479e0778c5"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-8"
    sha256 cellar: :any,                 arm64_sequoia: "68dc6842ab4dec4d711f4de6b5c0727c699ac1ce42e51be9dc236efde172ebf3"
    sha256 cellar: :any,                 arm64_sonoma:  "fd3a04df1c6fd692252a4770f295ca675c942eaff16e1e55a44a3d728c368181"
    sha256 cellar: :any,                 ventura:       "f5471b3dc0f7e4676599a64410aa7973f5d006729d83bb08dabe4b51a23b10ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dc58ce404f497cfd7b655ec47869c86dbe48c5655da87956098007967ec6864"
  end

  def name_version
    "amber-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "fftw"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "amber_calibrate -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page amber_calibrate")
  end
end
