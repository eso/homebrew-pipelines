class Edps < Formula
  include Language::Python::Virtualenv

  desc "ESO Data Processing System"
  homepage "https://www.eso.org/sci/software/edps.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/repositories/stable/src/edps/edps-1.5.3.tar.gz"
  sha256 "359c0b613078a994200f50978c92b690c386094508b8c5f168f4b5b4fb009eef"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/repositories/stable/src/edps/"
    regex(/href=.*?edps[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/edps-1.4.6"
    sha256 cellar: :any,                 arm64_sequoia: "43b5baa27e4a70e37b832faca540c171a04df4aa05ecaffda61b32feff0d0d73"
    sha256 cellar: :any,                 arm64_sonoma:  "bc5c61fa456d9419521696c119650cdb1426d86882413b24ff8ad52daa752610"
    sha256 cellar: :any,                 ventura:       "34b3718328d78edf8dfe72d0902efaf28f68d6090487467412d72e344b0e19a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f9d03445e05737f36d02e6e8675017f59a066243348f9fbc07754509c276d9"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "lapack"
  depends_on "libyaml"
  depends_on "openblas"
  depends_on "python@3.11"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a3/73/199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cde/anyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "astropy" do
    url "https://files.pythonhosted.org/packages/45/12/a1c582b3f9df5e2680eae0ed82c8057ae06d6130a1f7a5c0770fa899737e/astropy-7.0.1.tar.gz"
    sha256 "392feeb443b2437cd4c2e0641a65e0f15ba791e148e9b1e5ed7de7dfcb38e460"
  end

  resource "astropy-iers-data" do
    url "https://files.pythonhosted.org/packages/41/d3/20012c7a59486bcb35cd12a88e5c40f81a94a92c9f56ae7aaa6f1618775e/astropy_iers_data-0.2025.3.10.0.29.26.tar.gz"
    sha256 "dd4865861f00dec8a442ef8135f034675a7b05f17846562e2ea71678f5dbaa97"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/1c/ab/c9f1e32b7b1bf505bf26f0ef697775960db7932abeb7b516de930ba2705f/certifi-2025.1.31.tar.gz"
    sha256 "3d5da6925056f6f18f119200434a4780a94263f10d1c21d032a6f6b2baa20651"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/b5/28/c5d26e5860df807241909a961a37d45e10533acef95fc368066c7dd186cd/fastapi-0.115.11.tar.gz"
    sha256 "cc81f03f688678b92600a65a5e618b93592c65005db37157147204d8924bf94f"
  end

  resource "frozendict" do
    url "https://files.pythonhosted.org/packages/bb/59/19eb300ba28e7547538bdf603f1c6c34793240a90e1a7b61b65d8517e35e/frozendict-2.4.6.tar.gz"
    sha256 "df7cd16470fbd26fc4969a208efadc46319334eb97def1ddf48919b351192b8e"
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
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/1d/06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937f/networkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/fb/90/8956572f5c4ae52201fdec7ba2044b2c882832dcec7d5d0922c9e9acf2de/numpy-2.2.3.tar.gz"
    sha256 "dbdc15f0c81611925f382dfa97b3bd0bc2c1ce19d4fe50482cb0ddc12ba30020"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b7/ae/d5220c5c52b158b1de7ca89fc5edb72f304a70a4c540c84c8844bf4008de/pydantic-2.10.6.tar.gz"
    sha256 "ca5daa827cce33de7a42be142548b0096bf05a7e7b365aebfa5f8eeec7128236"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/fc/01/f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abc/pydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
  end

  resource "pyerfa" do
    url "https://files.pythonhosted.org/packages/71/39/63cc8291b0cf324ae710df41527faf7d331bce573899199d926b3e492260/pyerfa-2.0.1.5.tar.gz"
    sha256 "17d6b24fe4846c65d5e7d8c362dcb08199dc63b30a236aedd73875cc83e1f6c0"
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
    url "https://files.pythonhosted.org/packages/04/1b/52b27f2e13ceedc79a908e29eac426a63465a1a01248e5f24aa36a62aeb3/starlette-0.46.1.tar.gz"
    sha256 "3c88d58ee4bd1bb807c0d1acb381838afc7752f9ddaec81bbe4383611d833230"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/a0/79/4af51e2bb214b6ea58f857c51183d92beba85b23f7ba61c983ab3de56c33/tinydb-4.8.2.tar.gz"
    sha256 "f7dfc39b8d7fda7a1ca62a8dbb449ffd340a117c1206b68c50b1a481fb95181d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/4b/4d/938bd85e5bf2edeec766267a5015ad969730bb91e31b44021dfe8b22df6c/uvicorn-0.34.0.tar.gz"
    sha256 "404051050cd7e905de2c9a7e61790943440b3416f49cb409f965d9dcd0fa73e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "true"
  end
end
