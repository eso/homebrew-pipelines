class EsopipeHawkiRecipes < Formula
  desc "ESO HAWKI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/hawki/hawki-kit-2.5.17-5.tar.gz"
  sha256 "8510bf1f6eea5ec2d0a4673bf9d6e5c288a04536fa1a90923f28b62767d12150"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?hawki-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-hawki-recipes-2.5.17-4"
    sha256 cellar: :any, arm64_tahoe:   "003e8f9388a84fca1e5d7cc0925cd6893d5ad62b4c8034293be167af7af71bad"
    sha256 cellar: :any, arm64_sequoia: "da889cb0a2aff38062074d9ae7c831b3e8932da62a7873e0107351c3df701e1f"
    sha256 cellar: :any, arm64_sonoma:  "5b1fa96b44b3754c286133ae7e4dc29edf1e55c94ccbf503e6c39b4db4d90a04"
    sha256 cellar: :any, sonoma:        "ff5596e1aedd19db5dc0392b271a94c71cb40c6090c99409069504f589402935"
    sha256 cellar: :any, x86_64_linux:  "3b58a1fc4afe882dec6793171c36f0698a5d77b8a78a881226e19c14b42782f2"
  end

  def name_version
    "hawki-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "esorex"
  depends_on "gsl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
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
    assert_match "hawki_cal_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page hawki_cal_dark")
  end
end
