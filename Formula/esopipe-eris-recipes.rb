class EsopipeErisRecipes < Formula
  desc "ESO ERIS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/eris/eris-kit-1.8.8-1.tar.gz"
  sha256 "fd50cc98d118e999cf8a671d8d704ce8e4bfe3e4430248e43ccafae0de0c36ff"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?eris-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-eris-recipes-1.8.8-1"
    sha256 cellar: :any,                 arm64_sequoia: "e871e29c5865775802c314839cd20e15b9d1e42e599b2f6d67148793daccdb7d"
    sha256 cellar: :any,                 arm64_sonoma:  "8575c7b6bdab3dd5d150fee5695f4f65941db6f99544bfe700659cf3fed1ce85"
    sha256 cellar: :any,                 ventura:       "96e3348f5db533a052e5ca8323507c506ce102241c9482da94ea5d26a6709802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61b0c06783826488da2a197aef64953db763386bc6f067216db94215aea185da"
  end

  def name_version
    "eris-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
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
    assert_match "eris_nix_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page eris_nix_dark")
  end
end
