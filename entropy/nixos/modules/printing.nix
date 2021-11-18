{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.epson-escpr
  ];

  # set up my printer at home
  hardware.printers.ensurePrinters = [
    {
      description = "My private printer";
      deviceUri = "https://192.168.178.30:631/ipp/print";
      location = "Home";
      model = "epson-inkjet-printer-escpr/Epson-XP-322_323_325_Series-epson-escpr-en.ppd";
      name = "Home";
    }
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
