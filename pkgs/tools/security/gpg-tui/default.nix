{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gpgme,
  libgpg-error,
  pkg-config,
  python3,
  libiconv,
  libresolv,
  x11Support ? true,
  libxcb,
  libxkbcommon,
}:

rustPlatform.buildRustPackage rec {
  pname = "gpg-tui";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    hash = "sha256-aHmLcWiDy5GMbcKi285tfBggNmGkpVAoZMm4dt8LKak=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VLBou/XNYTd8vJNT+ntShLCRy9pzjCwJlbDbfRX2ag8=";

  nativeBuildInputs = [
    gpgme # for gpgme-config
    libgpg-error # for gpg-error-config
    pkg-config
    python3
  ];

  buildInputs =
    [
      gpgme
      libgpg-error
    ]
    ++ lib.optionals x11Support [
      libxcb
      libxkbcommon
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      libresolv
    ];

  meta = with lib; {
    description = "Terminal user interface for GnuPG";
    homepage = "https://github.com/orhun/gpg-tui";
    changelog = "https://github.com/orhun/gpg-tui/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      dotlambda
      matthiasbeyer
    ];
    mainProgram = "gpg-tui";
  };
}
