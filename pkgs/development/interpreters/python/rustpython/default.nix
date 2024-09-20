{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, SystemConfiguration
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "rustpython";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "RustPython";
    repo = "RustPython";
    rev = "a8964f4108d9ba0f1b87ced33eef955922b4825d";
    hash = "sha256-mnUVxTBOGu7EXIo/R5MszQf+FpqmXPltCrTbNR81nPw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    allowBuiltinFetchGit = true;
  };

  # freeze the stdlib into the rustpython binary
  cargoBuildFlags = [ "--features=freeze-stdlib" ];

  buildInputs = lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  nativeCheckInputs = [ python3 ];

  meta = with lib; {
    description = "Python 3 interpreter in written Rust";
    homepage = "https://rustpython.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    #   = note: Undefined symbols for architecture x86_64:
    #       "_utimensat", referenced from:
    #           rustpython_vm::function::builtin::IntoPyNativeFn::into_func::... in
    #           rustpython-10386d81555652a7.rustpython_vm-f0b5bedfcf056d0b.rustpython_vm.7926b68e665728ca-cgu.08.rcgu.o.rcgu.o
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
