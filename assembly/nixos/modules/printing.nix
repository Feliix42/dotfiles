{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.epson-escpr
  ];

  # setup the printers at work
  #hardware.printers.ensurePrinters = [
    #{
      #description = "CC printer";
      #deviceUri = "";
      #location = "BAR/III51";
      #model = "Ricoh-MP_C307_PS.ppd";
      #name = "CC_small";
    #}
    #{
      #description = "PD printer (A3)";
      #deviceUri = "";
      #location = "BAR/III71B";
      #model = "Ricoh-MP_C3004_PS.ppd";
      #name = "PD_Chair";
    #}
  #];
}
