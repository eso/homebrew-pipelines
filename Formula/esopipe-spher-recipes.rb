class EsopipeSpherRecipes < Formula
  desc "ESO SPHERE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sphere/spher-kit-0.59.1-2.tar.gz"
  sha256 "e7df60bfdec1b80083157f52147d314aa59c4e9a009c2f4f02233cbb1997ba8a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?spher-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-spher-recipes-0.59.1-2"
    sha256 cellar: :any, arm64_tahoe:   "b143e0e8ad112ad58e92fbfd048222ef317d10f1b47a24083bdd7e610cbf0042"
    sha256 cellar: :any, arm64_sequoia: "959486ffdd94ca79944599788bca3d7b6b9078acff220faab4285627b49deed3"
    sha256 cellar: :any, arm64_sonoma:  "f4f5e63484a290682733a0e5365f8aca1fe5c245651e45c2d16e752f4d1d4c8a"
    sha256 cellar: :any, sonoma:        "26d1217f8e306cbc9460d743a66da141347fdfbea6fd4e0e2e7a3d6c470d006f"
    sha256 cellar: :any, x86_64_linux:  "295af2829f6ba8bc4dc054f36859410c07f08ce261fcdc9c050192c88b26b05a"
  end

  def name_version
    "spher-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "fftw"
  depends_on "gsl"
  depends_on "libcext"

  uses_from_macos "curl"

  def install
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("fftw")}"
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("wcslib")}"
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("cfitsio")}"

    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
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
    assert_match "sph_zpl_master_dark -- version",
                 shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page sph_zpl_master_dark")
  end
end
