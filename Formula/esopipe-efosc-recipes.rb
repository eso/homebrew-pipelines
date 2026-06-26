class EsopipeEfoscRecipes < Formula
  desc "ESO EFOSC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/efosc/efosc-kit-2.3.12-3.tar.gz"
  sha256 "4be4d075e41cc6933c5c044cb6e3b6ba3f08c8254650cb709907208fb5047079"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?efosc-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-efosc-recipes-2.3.12-3"
    sha256 arm64_tahoe:   "ad03506732e262f32ec0d6b1b4de7ab38623d1ac8b26756274eee75e3e489ecf"
    sha256 arm64_sequoia: "137a07d7f83f6fabcea65f0705e28f69575bfd230d787af844af4126d088cdb9"
    sha256 arm64_sonoma:  "aa1df3cc14a51a273592e11c86099831ecb04ab18d00a62f3db36e1ecfd4e8bc"
    sha256 sonoma:        "5acb0009bb8e89fc88bd72c23ca2bd0fa15003fb14394d23b387d02c785342d3"
    sha256 x86_64_linux:  "ba93b2e7be9e6a5a41c31144d2e5213a2ace8c92be6f57ecacd4ec234690b410"
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
