class EsopipeEfoscRecipes < Formula
  desc "ESO EFOSC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/efosc/efosc-kit-2.3.9-2.tar.gz"
  sha256 "515a11ddaa6f71d2ebcfff91433b782089f93af5fb7ce3daf973ccfb456f9bba"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?efosc-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-efosc-recipes-2.3.9-2"
    sha256 arm64_sequoia: "fdf5bd6aaa63ce71bcac460b2e388cc94bf0e66c9d412833deb32ba090c05b18"
    sha256 arm64_sonoma:  "0c898b5146da363ee3d2ef394b05596ca3b4b4b2983177e19372099774342cb0"
    sha256 ventura:       "82fb4aa4557f2946a48f69653fa9319829b2dbb06ba41460c42ec954384b557b"
    sha256 x86_64_linux:  "9ae729220b2baf59eefaad8b7de9ad8e238078c9abec413e35dbcc3a02aace7f"
  end

  def name_version
    "efosc-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
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
    assert_match "efosc_calib -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page efosc_calib")
  end
end
