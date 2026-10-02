class EsopipeEfoscRecipes < Formula
  desc "ESO EFOSC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/efosc/efosc-kit-2.3.12-4.tar.gz"
  sha256 "266c66920c6c71d611eef38780833329f117dd0ac3666030e24b0486f37bad3b"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?efosc-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-efosc-recipes-2.3.12-4_1"
    sha256 arm64_tahoe:   "93bb6f5d56c169bdedc9f802e42ecb6c609bb0d8b67d282a5c810f285cc36e7b"
    sha256 arm64_sequoia: "175e0bd3a0d05959bf211823cb1909bbadb066f5e232524150a35006c1241b5d"
    sha256 x86_64_linux:  "7c656fd111b040b91b3926bf4259dd17dfc3ba2bfe48c78f2dbc7448beedb1ea"
  end

  def name_version
    "efosc-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "esorex"

  uses_from_macos "curl"

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
                (HOMEBREW_PREFIX/"share/esopipes/datastatic").to_s,
                audit_result: false

      inreplace workflow,
                "ROOT_DATA_PATH_TO_REPLACE/reflex_input",
                (HOMEBREW_PREFIX/"share/esopipes/datademo").to_s,
                audit_result: false

      inreplace workflow,
                "ROOT_DATA_PATH_TO_REPLACE",
                "$HOME/reflex_data",
                audit_result: false

      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "efosc_calib -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page efosc_calib")
  end
end
