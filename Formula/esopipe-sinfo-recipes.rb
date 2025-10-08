class EsopipeSinfoRecipes < Formula
  desc "ESO SINFONI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sinfoni/sinfo-kit-3.3.6-8.tar.gz"
  sha256 "f199776291765ca4f04077b43f6b86bd22812fea2ffcb6a9dbf43ed6f3733ed1"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?sinfo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-sinfo-recipes-3.3.6-8_1"
    sha256 cellar: :any,                 arm64_tahoe:   "bf3823950ee94dbb433cca0a0746665ee78a1aa3f4de1fe786010e06da8fe360"
    sha256 cellar: :any,                 arm64_sequoia: "759f43701b9b3892446318309b3c4bf1d41eb3cf9bd3150f9b749efddf6fdb8f"
    sha256 cellar: :any,                 arm64_sonoma:  "8af2d25fd8c0ec1149bc5d30864a59b71a7d2f02d7ebdb1e44d4698e82359476"
    sha256 cellar: :any,                 sonoma:        "d3ec729471568d11b5e8d0c0628bbfafa18188239582adcc37ec020bb11460ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d02c21730a30788532caf3d8a136a93574f8bee821da688c220b2a4d73f740a6"
  end

  def name_version
    "sinfo-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
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
    assert_match "sinfo_rec_mdark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page sinfo_rec_mdark")
  end
end
