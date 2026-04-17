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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-efosc-recipes-2.3.12-1"
    sha256 arm64_tahoe:   "7e4e4ac19ab296afffec5d106a95fcbf45c5566bf0a9d33803a3e78aae10fe68"
    sha256 arm64_sequoia: "589dc6c5f4165fb1bead5c2d8bb1f9dde2ba63936149f328525bd7009797e32b"
    sha256 arm64_sonoma:  "61d5e390ec5b22387e2ef44732c4d9ae44ec2cc36098b3dafed6759c211eb19a"
    sha256 sonoma:        "209d38617bc3b2ab69e0b7431c526470df9792a2649b2545fedced072bf1c9fb"
    sha256 x86_64_linux:  "ab44eb1d8479487135e95e644b1f6dc26a072aa6db04e91f8de1fcae85e5de91"
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
