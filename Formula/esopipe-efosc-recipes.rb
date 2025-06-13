class EsopipeEfoscRecipes < Formula
  desc "ESO EFOSC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/efosc/efosc-kit-2.3.11.tar.gz"
  sha256 "d2733147979e490382eb970c761d5282803eea8fa47945022b184a126782b561"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?efosc-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  def name_version
    "efosc-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl"
  depends_on "esorex"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}"
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
