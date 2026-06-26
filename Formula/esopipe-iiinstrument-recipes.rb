class EsopipeIiinstrumentRecipes < Formula
  desc "ESO example template instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/iiinstrument-kit-0.1.16-6.tar.gz"
  sha256 "57d62106ad3f26582dce3d6c5467b76a8a75835429fd074786a9cf4dbc7b1806"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/instruments/iiinstrument/"
    regex(/href=.*?iiinstrument-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-iiinstrument-recipes-0.1.16-6"
    sha256 cellar: :any, arm64_tahoe:   "b5d81f0b2e2c8b62c057888c14c71da9cfcb21398c1c6ae5ea4c6c8b418aa3d5"
    sha256 cellar: :any, arm64_sequoia: "cdc80d269c09c4d8e8c456f82af032e5d59c79c22772bae531598e52de1d23e9"
    sha256 cellar: :any, arm64_sonoma:  "c39adde1f5c798d06d6722d8da4970168af78fa3a92d3ef1c9e04449d69b39fa"
    sha256 cellar: :any, sonoma:        "ebe426ee353b8506de9b24745bb75de84df8e107fba64edd7b96f32ebd9c8330"
    sha256 cellar: :any, x86_64_linux:  "c6130ad797a093684550b464446e0b002d818c5569b3d37df86621a8448e7d9e"
  end

  def name_version
    "iiinstrument-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
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
    assert_match "rrrecipe -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page rrrecipe")
  end
end
