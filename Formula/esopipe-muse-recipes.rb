class EsopipeMuseRecipes < Formula
  desc "ESO MUSE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/muse/muse-kit-2.11.0-2.tar.gz"
  sha256 "c18254628690f6eb78a16751d5f717c11336e67c6f2e0f56ba75c9a4a9b37eb1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?muse-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-muse-recipes-2.11.0-2"
    sha256 cellar: :any, arm64_tahoe:   "33d5d5f648856a2baf9be5123b41d946e7c74218e934240faba7db66d25addf2"
    sha256 cellar: :any, arm64_sequoia: "873c222ce09829816ed00b3f6446099d3c803e744c692beb646175addd35735f"
    sha256 cellar: :any, arm64_sonoma:  "5769af1a315259f42ec8c52184c3bf48ac27e3754e6be7d6e375aa8579d445a3"
    sha256 cellar: :any, sonoma:        "a526b559377cc1798738cea4a23c299796d5a370484aa1a88aef6964cb2ac069"
    sha256 cellar: :any, x86_64_linux:  "7cac277d7b1242fc8a4daba35eb714a1a01fd9a666d427632cef1d06a7c8a90d"
  end

  def name_version
    "muse-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "libcext"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
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
    assert_match "muse_bias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page muse_bias")
  end
end
