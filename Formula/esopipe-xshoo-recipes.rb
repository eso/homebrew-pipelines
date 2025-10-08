class EsopipeXshooRecipes < Formula
  desc "ESO XSHOOTER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/xshooter/xshoo-kit-3.8.3-1.tar.gz"
  sha256 "cff7bff1ee3e880e75269e7b2a153078a018bec35bbaeaf0c382675a52100281"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?xshoo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-xshoo-recipes-3.8.3-1_1"
    sha256 cellar: :any,                 arm64_tahoe:   "429b9e972283748e68c7d5a436f24102c35642655bf85ebfd05fb9a60d67df4d"
    sha256 cellar: :any,                 arm64_sequoia: "1e92aa198568073d06f513373a017114ef1c553b0a22615d5a90316a869b0487"
    sha256 cellar: :any,                 arm64_sonoma:  "ddcfa2b8410c6ec8212497d9119ad5b7c47388e727f750d3f2fae1cf9e5d782c"
    sha256 cellar: :any,                 sonoma:        "e42d0ffc64608362c25d1d5c0247974298a77fe0e186a7976d26add537d1c942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9776aa25e2b7469f9562d9aafbe063cd765436f67e3c852f61c1cdbf37e041"
  end

  def name_version
    "xshoo-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "telluriccorr"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}",
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
    assert_match "xsh_mdark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page xsh_mdark")
  end
end
