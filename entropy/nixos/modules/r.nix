{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  let
    R-with-my-packages = rWrapper.override {
      packages = with rPackages; [
        ggplot2
        tidyverse
        rlang
        lazyeval
        patchwork
      ];
    };
    rstudioEnv = rstudioWrapper.override {
      packages = with rPackages; [
        ggplot2
        tidyverse
        rlang
        lazyeval
        patchwork
      ];
    };
  in
    #[ R-with-my-packages rstudioEnv ];
    [ R-with-my-packages ];
}
