{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  gmt,
  numpy,
  netcdf4,
  pandas,
  packaging,
  xarray,
  pytest-mpl,
  ipython,
  ghostscript,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygmt";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "GenericMappingTools";
    repo = "pygmt";
    tag = "v${version}";
    hash = "sha256-sse1Cxzsrhg9X9zH/XSUtF/7YHrSUHYGtn4qoq5qdM4=";
  };

  postPatch = ''
    substituteInPlace pygmt/clib/loading.py \
      --replace-fail "env.get(\"GMT_LIBRARY_PATH\")" "env.get(\"GMT_LIBRARY_PATH\", \"${gmt}/lib\")"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    numpy
    netcdf4
    pandas
    packaging
    xarray
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
    ghostscript
    ipython
  ];

  # The *entire* test suite requires network access
  doCheck = false;

  postBuild = ''
    export HOME=$TMP
  '';

  pythonImportsCheck = [ "pygmt" ];

  meta = {
    description = "Python interface for the Generic Mapping Tools";
    homepage = "https://github.com/GenericMappingTools/pygmt";
    license = lib.licenses.bsd3;
    changelog = "https://github.com/GenericMappingTools/pygmt/releases/tag/${src.tag}";
    teams = [ lib.teams.geospatial ];
  };
}
