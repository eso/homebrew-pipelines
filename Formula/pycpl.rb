class Pycpl < Formula
  include Language::Python::Virtualenv

  desc "Python Language Bindings for CPL"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/pycpl-1.0.3.tar.gz"
  sha256 "b797cc10f33705a2a7bd38f18c1d6ab9011132e62638848dae608a8f26e9df4d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/"
    regex(/href=.*?pycpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pycpl-1.0.2"
    sha256 cellar: :any,                 arm64_sequoia: "d9c44e0ce786b568527fe5712d5bae76bcd08b8a861e7dc377713b8485747f5c"
    sha256 cellar: :any,                 arm64_sonoma:  "fcfe4f25b5b60e0c7637ef0cd77bfde82e53637915be9978d4e9fbc1fa2b72cb"
    sha256 cellar: :any,                 ventura:       "3aa64a6dedc08c904c37b699abcebb47f0ce6db3e5a309dd2c48a927e2bc3e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b32eb115e416367e9e90ad8aaa54f585449c97e85319c4cc7573ba425bfb455"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "cpl"
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
