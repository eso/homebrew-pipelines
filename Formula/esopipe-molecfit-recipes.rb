class EsopipeMolecfitRecipes < Formula
  desc "ESO MOLECFIT instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/molecfit/molecfit-kit-4.4.2-5.tar.gz"
  sha256 "6a74b04c613cfe221cc0824659eb86ec6d17afbe78fcd1261e2efaa45392480b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?molecfit-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-molecfit-recipes-4.4.2-3"
    sha256 cellar: :any,                 arm64_sequoia: "904e3ee69cdd0ef3579c1730e88be5b1f78111fe164b2d245fd58f6185686910"
    sha256 cellar: :any,                 arm64_sonoma:  "c3f1c85c8fb8d7b7c7910b4c58aa714aa8e3d817b543300e976534ab5fe6e3c6"
    sha256 cellar: :any,                 ventura:       "591337970658ed5544cc93d6fa5c89c156e293c1cbd3ea80a8f2ace0fecd944c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa57f18f10c3e35f871bd58363e1c61c7408cd61f59fae8bfe1f381ef2a2d251"
  end

  def name_version
    "molecfit-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "telluriccorr"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}"
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
      if workflow.read.include?("RAW_DATA_PATH_TO_REPLACE")
        inreplace workflow, "RAW_DATA_PATH_TO_REPLACE", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "molecfit_model -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page molecfit_model")
  end
end
