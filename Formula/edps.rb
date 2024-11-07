class Edps < Formula
  include Language::Python::Virtualenv

  desc "ESO Data Processing System"
  homepage "https://www.eso.org/sci/software/edps.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/edps/edps-1.4.4.tar.gz"
  sha256 "38870db3049af96b39fdea9541ab8efc1b1d666d2d9d622b1436e515811d4adc"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/edps/"
    regex(/href=.*?edps[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/edps-1.4.4_1"
    sha256 cellar: :any,                 arm64_sequoia: "7bda5888a12122d6b10af291765e2fdc3ddf7af6cc4c0c29d067a5543c1e1872"
    sha256 cellar: :any,                 arm64_sonoma:  "866b268098a835009428eb35dca87fd9015518088934bd8e7a3f5ded6c65ae40"
    sha256 cellar: :any,                 ventura:       "3e54f06412d4c6a815989c1abe666ca828e98d473a36d5d90005203effa404ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfc8fef03de5b5cecbde53819f4328d2bbf8ac7ef54800429b1d30493a32916c"
  end

  depends_on "cmake"
  depends_on "lapack"
  depends_on "libyaml"
  depends_on "openblas"
  depends_on "python@3.11"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/78/49/f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8/anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
  end

  resource "astropy" do
    url "https://files.pythonhosted.org/packages/13/25/adf5ee49f3990fc5cde050cce9c6f0a74a78af4eb18bd3aec8f1eecd1a26/astropy-6.1.4.tar.gz"
    sha256 "361558e2b093a99bebe69f1fd47fac86a192607a4c16ed39ba0a800b2ab60c34"
  end

  resource "astropy-iers-data" do
    url "https://files.pythonhosted.org/packages/48/d6/88ac34b333d02c45119701199cac5b3144d4bb646fb1cefd03542339e3f9/astropy_iers_data-0.2024.10.7.0.32.46.tar.gz"
    sha256 "349ff09294f03112d9391a5ad660135bf2fcef7de411a52c20bcf8598fb029d1"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b0/ee/9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1/certifi-2024.8.30.tar.gz"
    sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/7b/5e/bf0471f14bf6ebfbee8208148a3396d1a23298531a6cc10776c59f4c0f87/fastapi-0.115.0.tar.gz"
    sha256 "f93b4ca3529a8ebc6fc3fcf710e5efa8de3df9b41570958abf1d97d843138004"
  end

  resource "frozendict" do
    url "https://files.pythonhosted.org/packages/56/06/baebef78b39a4b483f817265ed4fe0ac98bc91e371007de18a3192c8073b/frozendict-2.4.5.tar.gz"
    sha256 "fd7add309789595c044c0155a0bddfa9d20c77f65de1e33a14aa3033b936ef63"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/36/2b/20ad9eecdda3f1b0dc63fb8f82d2ea99163dbca08bfa392594fc2ed81869/networkx-3.4.1.tar.gz"
    sha256 "f9df45e85b78f5bd010993e897b4f1fdb242c11e015b101bd951e5c0e29982d8"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/4b/d1/8a730ea07f4a37d94f9172f4ce1d81064b7a64766b460378be278952de75/numpy-2.1.2.tar.gz"
    sha256 "13532a088217fa624c99b843eeb54640de23b3414b14aa66d023805eb731066c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/20/e6/89d6ba0c0a981fd7e3129d105502c4cf73fad1611b294c87b103f75b5837/pydantic-1.10.18.tar.gz"
    sha256 "baebdff1907d1d96a139c25136a9bb7d17e118f133a76a2ef3b845e831e3403a"
  end

  resource "pyerfa" do
    url "https://files.pythonhosted.org/packages/6c/aa/a5f67966decfe415684e2505bb0b3dcaadb8c6ccc6421813b1ab34451060/pyerfa-2.0.1.4.tar.gz"
    sha256 "acb8a6713232ea35c04bc6e40ac4e461dfcc817d395ef2a3c8051c1a33249dd3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/42/b4/e25c3b688ef703d85e55017c6edd0cbf38e5770ab748234363d54ff0251a/starlette-0.38.6.tar.gz"
    sha256 "863a1588f5574e70a821dadefb41e4881ea451a47a3cd1b4df359d4ffefe5ead"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/8b/25/f3e8142463302f311ee03928640ac1415d06644666e8841337a29c099710/tinydb-4.8.1.tar.gz"
    sha256 "09c4c6a239da9be676b948f1f28074cffd1cf08e7af920c1df50424cc8bee8d6"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/76/87/a886eda9ed495a3a4506d5a125cd07c54524280718c4969bde88f075fe98/uvicorn-0.31.1.tar.gz"
    sha256 "f5167919867b161b7bcaf32646c6a94cdbd4c3aa2eb5c17d36bb9aa5cfd8c493"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "true"
  end
end
