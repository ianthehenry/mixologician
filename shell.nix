with import <nixpkgs> {}; mkShell {
  nativeBuildInputs = [ souffle python39Packages.cram ];
}
