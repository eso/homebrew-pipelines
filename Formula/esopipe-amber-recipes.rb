class EsopipeAmberRecipes < Formula
  desc "ESO AMBER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/amber/amber-kit-4.4.5-8.tar.gz"
  sha256 "b2a8576ba2fc8ca620b39db7f4ca652375276a10a984183668e5d8479e0778c5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?amber-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-amber-recipes-4.4.5-6"
    sha256 cellar: :any,                 arm64_sequoia: "49cf08b09af436667fa3e1de487a4585d2613ee416b7d1fbc683e7747733f1a4"
    sha256 cellar: :any,                 arm64_sonoma:  "db54bbe3ecb2796f1aa748c42910ba34070472fcfad9f3e359709c4411dd5cde"
    sha256 cellar: :any,                 ventura:       "2ec178aeb80b4a9391651cf59ee1742e37929c2d9629df495b27ed95a8967a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0329c0e129b0d1b1a8a9b1ec07826e272522437d5d956e1d62cf975b3a7b4743"
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
