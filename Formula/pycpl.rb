class Pycpl < Formula
  include Language::Python::Virtualenv

  desc "Python Language Bindings for CPL"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/pycpl-1.0.1.tar.gz"
  sha256 "4c2c52496a6aeb5de887e06d1c8f656f4b45908bf5cfeb076d80eae1eb156f25"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/"
    regex(/href=.*?pycpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pycpl-1.0.1"
    sha256 cellar: :any,                 arm64_sequoia: "0e8cb9aea593f59d0654637307f079cd2ed8fc631a670a0f99061e7a9ce8e1aa"
    sha256 cellar: :any,                 arm64_sonoma:  "f245f752e73f84e435437af21015f0f6eba0efd5d9ebd974a115f09aac062d7d"
    sha256 cellar: :any,                 ventura:       "94d0876d401533ec1ab450fd4d20672e642d5698fc86a9498c2cf699a5ecc568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a13b719479d47455f216536646773f84b18b03426cdf37c061c61e259b52d1b"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "cpl"
  depends_on "lapack"
  depends_on "libyaml"
  depends_on "openblas"
  depends_on "python@3.11"

  resource "astropy" do
    url "https://files.pythonhosted.org/packages/6a/12/d6ad68d5acd751e3827d54a64333e0dd789bcc747fe9528f5758b35421f8/astropy-7.0.0.tar.gz"
    sha256 "e92d7c9fee86eb3df8714e5dd41bbf9f163d343e1a183d95bf6bd09e4313c940"
  end

  resource "astropy-iers-data" do
    url "https://files.pythonhosted.org/packages/e0/3c/1e22649b559f0d18001f9a5e8b095fbe7330c3aac560a9c46bc1b2012841/astropy_iers_data-0.2025.1.13.0.34.51.tar.gz"
    sha256 "de6fafd52088f589e2ef5bf797242965f3dfd77b667ea066f941fc98ddeda604"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/f2/a5/fdbf6a7871703df6160b5cf3dd774074b086d278172285c52c2758b76305/numpy-2.2.1.tar.gz"
    sha256 "45681fd7128c8ad1c379f0ca0776a8b0c6583d2f69889ddac01559dfe4390918"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pyerfa" do
    url "https://files.pythonhosted.org/packages/71/39/63cc8291b0cf324ae710df41527faf7d331bce573899199d926b3e492260/pyerfa-2.0.1.5.tar.gz"
    sha256 "17d6b24fe4846c65d5e7d8c362dcb08199dc63b30a236aedd73875cc83e1f6c0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def python3
    "python3.11"
  end

  def install
    ENV["PYCPL_RECIPE_DIR"] = HOMEBREW_PREFIX/"lib/esopipes-plugins"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    virtualenv_install_with_resources

    pth_contents = "import site; site.addsitedir('#{libexec}/lib/#{python3}/site-packages')\n"
    (prefix/Language::Python.site_packages(python3)/"pycpl-dependencies.pth").write pth_contents
  end

  test do
    system "true"
  end
end
