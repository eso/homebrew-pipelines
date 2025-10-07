class Pycpl < Formula
  include Language::Python::Virtualenv

  desc "Python Language Bindings for CPL"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/pycpl-1.0.3.tar.gz"
  sha256 "b797cc10f33705a2a7bd38f18c1d6ab9011132e62638848dae608a8f26e9df4d"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/"
    regex(/href=.*?pycpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pycpl-1.0.3_2"
    sha256 cellar: :any,                 arm64_sequoia: "87f689c19ea54898110ebbff9ff5a12c4041f283e3b153d3133968b58b27c67a"
    sha256 cellar: :any,                 arm64_sonoma:  "76a8858ddc564e4b524c826b311891f4d9b26373c654037eeb0dc293b68b8895"
    sha256 cellar: :any,                 ventura:       "6e5d979a6119ae635c48e9d8f4d132d297c95ef1f76b7953fe8d30c0fdd7f581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26fb5c1f1dfb7b1459858a6dc3918c70604f968c3b2dd18469a50175a78d8407"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "cpl@7.3.2"
  depends_on "lapack"
  depends_on "libyaml"
  depends_on "openblas"
  depends_on "python@3.11"

  resource "astropy" do
    url "https://files.pythonhosted.org/packages/83/91/124d020cea78e4e4b6db7ff726c2c2e4a5865293d0a4355d13b0312d99f1/astropy-7.1.0.tar.gz"
    sha256 "c8f254322295b1b8cf24303d6f155bf7efdb6c1282882b966ce3040eff8c53c5"
  end

  resource "astropy-iers-data" do
    url "https://files.pythonhosted.org/packages/31/08/6ed082754751561597c8e92cfc6545716396cbd3569e362127bf75a84d95/astropy_iers_data-0.2025.5.19.0.38.36.tar.gz"
    sha256 "f273428b408f30c618a72e454dd68434564dea69d891777df36de3f1399e0fa5"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/76/21/7d2a95e4bba9dc13d043ee156a356c0a8f0c6309dff6b21b4d71a073b8a8/numpy-2.2.6.tar.gz"
    sha256 "e29554e2bef54a90aa5cc07da6ce955accb83f21ab5de01a62c8478897b264fd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
