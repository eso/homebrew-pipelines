class EsopipeSpherRecipes < Formula
  desc "ESO SPHERE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sphere/spher-kit-0.58.1-1.tar.gz"
  sha256 "e158605ccd5df050712c7e77bcb420a8fcd2e7afb99adfc57a244f5d5a7932b7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?spher-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-spher-recipes-0.58.1-1"
    sha256 cellar: :any,                 arm64_sequoia: "a31166a698cae4cd6607da7e87c0f86618652c4e8dc3b8d21fe659d72d2522a1"
    sha256 cellar: :any,                 arm64_sonoma:  "82fa11b0dc44af7fb46da7e94c329c45b121074910755a48894933e0d83f5012"
    sha256 cellar: :any,                 ventura:       "9fdfb262ff8b993a9050a8278e95ff4af7ad4dca2ff35dc83cff0ed4ceb12dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55522b914aada027789816f129b3f1532805a06f89e700362f862c9f4fed0cea"
  end

  def name_version
    "spher-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
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
    assert_match "sph_zpl_master_dark -- version",
                 shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page sph_zpl_master_dark")
  end
end
