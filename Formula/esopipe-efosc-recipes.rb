class EsopipeEfoscRecipes < Formula
  desc "ESO EFOSC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/efosc/efosc-kit-2.3.12-1.tar.gz"
  sha256 "3e81423924b2069e3f263c93e6c5fa03ef0d90d8dfd5b52023df3ee9ef7a3ecf"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?efosc-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-efosc-recipes-2.3.12"
    sha256 arm64_tahoe:   "70937c11e200e783ea55252338487c85598f7e7648fc35efa13852f4bb83d4d3"
    sha256 arm64_sequoia: "9c02601f3abd8760e5239929f6b8ae0480f72aca1f469159a49306fbb1e4ac9d"
    sha256 arm64_sonoma:  "5baa29c76cb4f63b2834bfca96f56e4a60921abe85317764aa32d9cd5b943350"
    sha256 sonoma:        "61fb7c61ece37a028c9abcc8b6544ee67915011f1ff22b290e16c555d68ffbb6"
    sha256 x86_64_linux:  "658c6f10c6f64bad0b9957cd4022fe785593cdc3708911edb0facc9c53050e1f"
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
