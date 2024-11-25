class EsopipeErisRecipes < Formula
  desc "ESO ERIS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/eris/eris-kit-1.7.0.tar.gz"
  sha256 "66b7e71f7c27112622dcfba4734b0a1cc06a35c26728ee723c99618990c2281a"
  license "GPL-2.0-or-later"

  def name_version
    "eris-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?eris-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-eris-recipes-1.6.0_3"
    sha256 cellar: :any,                 arm64_sequoia: "eaf1d7d231c73b016a6bc33e0b78629b913ee0257dee5a3523b9bb2cc8075deb"
    sha256 cellar: :any,                 arm64_sonoma:  "4256ac3e1b58ecaeff47f4cda0be8208fdc73b635bae7a6e7e92ecaae445796d"
    sha256 cellar: :any,                 ventura:       "26a4446576a3a8056a0375b59fdf1c3b5b5aecd2fbe26c6dbcf6dfc5630777f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "168df63aa8da94efb634dbfafd78091bd12ea8e14743ec3ce9b848c3afda03cb"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio@4.2.0"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
             "--with-cfitsio=#{Formula["cfitsio@4.2.0"].prefix}",
             "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
             "--with-erfa=#{Formula["erfa"].prefix}",
             "--with-curl=#{Formula["curl"].prefix}",
             "--with-gsl=#{Formula["gsl@2.6"].prefix}"
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
