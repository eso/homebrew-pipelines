class EsopipeGirafRecipes < Formula
  desc "ESO GIRAFFE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/giraffe/giraf-kit-2.18.4-4.tar.gz"
  sha256 "97a0cbf687218f036f51cd84a1c60901a910a4fc9998ad77607e78784039d5ba"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?giraf-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-giraf-recipes-2.18.4-4"
    sha256 cellar: :any,                 arm64_tahoe:   "e598ee3558d70b169197b431dbe6cc31a14bd2f17b1cf997d6f5fd7a94bb6b5b"
    sha256 cellar: :any,                 arm64_sequoia: "e30cb046200d7b6c671bec5337b4fc5956c2c323b8ea4bb6e1481996a7754b82"
    sha256 cellar: :any,                 arm64_sonoma:  "f2bad804b1c571475b4b02e80d1d145fdba64139f0adffef6b166734bbbe54f0"
    sha256 cellar: :any,                 sonoma:        "ac972a319db8118c200fcfd6577c6e05299ab8296943e169dadcb02c5475eeae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9610657df5c0740b99fd5359e7a083d75ecb75e6b448874e334206025b8a23b"
  end

  def name_version
    "giraf-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.3.2"
  depends_on "esorex"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}"
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
    assert_match "gimasterbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page gimasterbias")
  end
end
