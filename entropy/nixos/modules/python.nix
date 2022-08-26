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
      #jupyter
    ]; 
    python-with-my-packages = python3.withPackages my-python-packages;
  in
    [ python-with-my-packages ];
}
