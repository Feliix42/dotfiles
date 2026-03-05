# This file is not linked
{ pkgs, lib, ... }:

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

      # NOTE(feliix42): broken at the moment
      # jupyter

      ## xDSL
      # (
      #   buildPythonPackage rec {
      #     pname = "xdsl";
      #     version = "0.57.0";
      #     src = fetchPypi {
      #       inherit pname version;
      #       sha256 = "sha256-7+y3A2plDwDqWO8BLMV1TIXucjvHZSJAKYu285ygYW8=";
      #       #sha256 = lib.fakeSha256;
      #     };
      #     doCheck = false;
      #     pyproject = true;
      #     build-system = [ setuptools ];
      #     propagatedBuildInputs = [
      #       pkgs.python3Packages.pip
      #       pkgs.python3Packages.pytest
      #       pkgs.python3Packages.filecheck
      #       pkgs.python3Packages.versioneer
      #       # pkgs.python3Packages.lit
      #       pkgs.lit
      #       pkgs.python3Packages.immutabledict
      #       pkgs.python3Packages.ordered-set
      #       pkgs.python3Packages.typing-extensions
      #       pkgs.python3Packages.setuptools-scm
      #     ];
      #   }
      # )
    ]; 
    python-with-my-packages = python3.withPackages my-python-packages;
  in
  [
    python-with-my-packages 
    uv
  ];
}
