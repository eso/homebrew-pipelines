class EsopipeVcamRecipes < Formula
  desc "ESO VIRCAM instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/vircam/vcam-kit-2.3.17-5.tar.gz"
  sha256 "15e63b1c74641294653770074ec55a4008b95e043bc0c6ba0f6b7d0b41f1eb20"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?vcam-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-vcam-recipes-2.3.17-5"
    sha256 cellar: :any, arm64_tahoe:   "90e7c830ae9a0081d0aa6b748d0cf0afdc11b35606f25afcd8da4372cd0a5b30"
    sha256 cellar: :any, arm64_sequoia: "1a1745c206e7207d2b74418f1d1e7c503b5a2adec0c48500b9748cf2f8c237fd"
    sha256 cellar: :any, arm64_sonoma:  "d58d2b714e7623e9e7332a5ce3fab9793113d02cd20efbca127cd6b4057f7254"
    sha256 cellar: :any, sonoma:        "8c5a96d0f97b35da63ae55f3a3999db60f678c485d0b50f74444dde488c0b878"
    sha256 cellar: :any, x86_64_linux:  "559defc7a2f7bd6ff2f45be87fc006f5e17fad23058eacb02ea387fa482b0bb5"
  end

  def name_version
    "vcam-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "esorex"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}"
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
    assert_match "vircam_dark_combine -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page vircam_dark_combine")
  end
end
