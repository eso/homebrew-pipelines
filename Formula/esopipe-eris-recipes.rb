class EsopipeErisRecipes < Formula
  desc "ESO ERIS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/eris/eris-kit-1.9.0.tar.gz"
  sha256 "cbe159ad6bc5b4bb76d75f6e85cc92b538f5a37f81e8e05d9e0aa84f8d34dc29"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?eris-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-eris-recipes-1.9.0"
    sha256 cellar: :any,                 arm64_tahoe:   "d0229cdd85304d72bba55216d1cb44fc78049beccf95d1ffa09a300cfb9942fa"
    sha256 cellar: :any,                 arm64_sequoia: "c5dbade43102fbff84162ace0ddf88bfc75d8f87f4921d1e9ed1aab318ce6b39"
    sha256 cellar: :any,                 arm64_sonoma:  "64e6ce89f7eb92200e446c1b67e15beb810f85dddc888468144caf52117ee5e8"
    sha256 cellar: :any,                 sonoma:        "3d63d5f356a58036ca74789413b706934917a09ba3d72c69cbd84b9f823ba95b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07aab82983d170af35a43c84fbb005a7aba1e7311de8ddb687d9ee159e2a11bd"
  end

  def name_version
    "eris-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}"
      system "make", "install"
    end
  end

  def post_install
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"
    workflow_dir_1.glob("*.xml").each do |workflow|
      ohai "Updating #{workflow}"
      if workflow.read.include?("CALIB_DATA_PATH_TO_REPLACE")
        inreplace workflow, "CALIB_DATA_PATH_TO_REPLACE", HOMEBREW_PREFIX/"share/esopipes/datastatic"
      end
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      end
      if workflow.read.include?("$ROOT_DATA_DIR/reflex_input")
        inreplace workflow, "$ROOT_DATA_DIR/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "eris_nix_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page eris_nix_dark")
  end
end
