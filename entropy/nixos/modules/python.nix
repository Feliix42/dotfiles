# This file is not linked
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  let
    my-python-packages = python-packages: with python-packages; [
      pygments
      pandas
      numpy
      pylint
      # rpy2
      # NOTE(feliix42): due to security vulnerability in the naughty zone for now.
      jupyter

      ## xDSL
      (
        buildPythonPackage rec {
          pname = "xdsl";
          version = "0.12.1";
          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-ZpZ7DTwlDTHeMUJ2SSe3PR+8iaZBShYelP5TkutKWS0=";
          };
          doCheck = false;
          propagatedBuildInputs = [
            pkgs.python3Packages.pip
            pkgs.python3Packages.pytest
            pkgs.python3Packages.filecheck
            # pkgs.python3Packages.lit
            pkgs.lit
            pkgs.python3Packages.immutabledict
          ];
        }
      )
    ]; 
    python-with-my-packages = python3.withPackages my-python-packages;
  in
    [ python-with-my-packages ];
}
