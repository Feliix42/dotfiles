{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  let
    R-with-my-packages = rWrapper.override {
      packages = with rPackages; [
        ggplot2
        rlang
        lazyeval
      ];
    };
  in
    [ R-with-my-packages ];
}
