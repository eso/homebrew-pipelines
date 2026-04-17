class EsopipeMatisseRecipes < Formula
  desc "ESO MATISSE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/matisse/matisse-kit-2.2.3-4.tar.gz"
  sha256 "a48b69767773541105f68971665514a635ba8a34827e504449f9483a743147b9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?matisse-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-matisse-recipes-2.2.3-4"
    sha256 cellar: :any,                 arm64_tahoe:   "eae5f895e22f1a45233f50cbcf5a836252e9a388710e9ec664b18880d24ed786"
    sha256 cellar: :any,                 arm64_sequoia: "920708334412d0e161b11889918ff0294d6fe59035ac39048fa3e1ac4b333e89"
    sha256 cellar: :any,                 arm64_sonoma:  "8bf3d498427ce69c080135cfd2a24af6f8329ad1285a9d0158b072d9d3d53d10"
    sha256 cellar: :any,                 sonoma:        "0aaf4e57b07f2224b924300c60396897d2a00b5f03c2bf03cc8210c052050492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eb088a0b84fe707f00a0ddb7ba47800cc7c9d9f36cd23d194aefd53f0ab6215"
  end

  def name_version
    "matisse-#{version.major_minor_patch}"
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
    assert_match "mat_wave_cal -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page mat_wave_cal")
  end
end
