class EsopipeEsotkRecipes < Formula
  desc "ESO ESOTK instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/esotk/esotk-kit-1.0.0-5.tar.gz"
  sha256 "adf05cc8006e420142a3241d80692cb8de3b9c54e8a781b45500cab0bc136548"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?esotk-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-esotk-recipes-1.0.0-5"
    sha256 cellar: :any, arm64_tahoe:   "41042b0615ae4e461d5fbf79c9aefa9e4dd67607d7917eb78806e50a05645b7a"
    sha256 cellar: :any, arm64_sequoia: "75d17e41ba303d308b7a6c117d0365c07f77f3d3f2fd921568e7e87b9e6447af"
    sha256 cellar: :any, arm64_sonoma:  "6e8e76375b37108dfd0db030be22c502bf7e9297787cc2cd2e86108bdff8c7a0"
    sha256 cellar: :any, sonoma:        "572ab6e43a5f1a28f4cef4c079b6081e67bab79158cf4c7b0d899475acad3cce"
    sha256 cellar: :any, x86_64_linux:  "a230f857d57274a5bf020af84abebfbc69703a9b6e4b3d8fb11ae977a2845705"
  end

  def name_version
    "esotk-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
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
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE/reflex_input")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "esotk_spectrum1d_combine -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page esotk_spectrum1d_combine")
  end
end
