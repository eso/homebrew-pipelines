class EsopipeVcamRecipes < Formula
  desc "ESO VIRCAM instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/vircam/vcam-kit-2.3.17-5.tar.gz"
  sha256 "15e63b1c74641294653770074ec55a4008b95e043bc0c6ba0f6b7d0b41f1eb20"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?vcam-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-vcam-recipes-2.3.17-5_1"
    sha256 cellar: :any, arm64_tahoe:   "a5e3a4039679f3c563c983d6bc79fef2a4c11b171ff74685568e0a3444bfe1f9"
    sha256 cellar: :any, arm64_sequoia: "c9cdbec0119fe45971340d407fc85525b3cfd3a8780d18e1ac4c5e4b25d269d0"
    sha256 cellar: :any, x86_64_linux:  "626697c0d6096a83afd9fa16d33387c61367ca066b15eb7916622bb30e587473"
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
      update_workflows
    end
  end

  def update_workflows
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"

    workflow_dir_1.glob("*.xml").each do |workflow|
      inreplace workflow,
                "CALIB_DATA_PATH_TO_REPLACE",
                (HOMEBREW_PREFIX/"share/esopipes/datastatic").to_s

      inreplace workflow,
                "ROOT_DATA_PATH_TO_REPLACE",
                "$HOME/reflex_data"

      inreplace workflow,
                "$ROOT_DATA_DIR/reflex_input",
                (HOMEBREW_PREFIX/"share/esopipes/datademo").to_s

      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "vircam_dark_combine -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page vircam_dark_combine")
  end
end
