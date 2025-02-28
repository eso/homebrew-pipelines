class EsopipeSpherRecipes < Formula
  desc "ESO SPHERE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sphere/spher-kit-0.56.0-6.tar.gz"
  sha256 "f99105178a212cb28492612d466d1973a6d0c45a278ed14384b13296f818b1f1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?spher-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-spher-recipes-0.56.0-6"
    sha256 cellar: :any,                 arm64_sequoia: "74b0b2896fba7c65e29e2c2bc48b7586c39287fd7d68f0622ab657a20d31c964"
    sha256 cellar: :any,                 arm64_sonoma:  "658ce7e1f1a95efc8a1af22b103216fcf7624ed469d0aa6c28c54db294c30d32"
    sha256 cellar: :any,                 ventura:       "9282d5ac525accea8bc3f0f677ea83f15550c7407ed1d14667e0f7bdcc69a748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b67a6eeaab75492c42b8167a973017bfa56ab323cca42a6984c4da3c26f9dc"
  end

  def name_version
    "spher-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["fftw"].opt_lib}"
    ENV.prepend "LDFLAGS", "-L#{Formula["wcslib"].opt_lib}"
    ENV.prepend "LDFLAGS", "-L#{Formula["cfitsio"].opt_lib}"

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
