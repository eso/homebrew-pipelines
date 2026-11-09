class EsopipeEfoscRecipes < Formula
  desc "ESO EFOSC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/efosc/efosc-kit-2.3.12-5.tar.gz"
  sha256 "c12beaf9948f9766c3c2dd15b22246f6c8cbacd79a62cc022e7238ac44c2a95d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?efosc-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-efosc-recipes-2.3.12-5"
    sha256 arm64_tahoe:   "7bf0dd0b9cb2aa1e71c005d8a5183b1fc5897ed232b550f6c4d65e4d8d5638e8"
    sha256 arm64_sequoia: "57872765ba60bc1d7976045729e518318125813210f6aecb62028ceac3297f02"
    sha256 x86_64_linux:  "d96cde7b5f6dd2adb82e2f6f24af07ea0a279ee881f44a2838f5fc9c879680ea"
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
