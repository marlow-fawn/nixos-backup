{ config, pkgs, lib, ...}:

{
#  services.headscale = {
#    enable = true;
#    address = "127.0.0.1";
#    port = 8443;
#    settings.dns.base_domain = "mesh.local";
#    settings.server_url = "https://mfawn.ddns.net";
#  };

#  services.jellyfin.enable = true;

  networking.firewall.allowedTCPPorts = [
    80   # HTTP
    443  # HTTPS
    8443
  ];
  

  services.nginx = {
    enable = true;
    virtualHosts."mfawn.ddns.net"= {
      root = "/var/www/site/public";
      addSSL = true;
      enableACME = true;
      listen = [ { addr = "0.0.0.0"; port = 8443; ssl = true; } ];  # Listen on port 8443
      locations."/" = {
        index = "index.html";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "marlow.fawn@gmail.com";
    certs."mfawn.ddns.net" = {
      webroot = "/var/www/site/public";
    };
  };

  services.ddclient = {
    enable = true;
    protocol = "noip";
    username = "wzmak8p";
    passwordFile = "/etc/secrets/noip-ddns-password";
    domains = [ "all.ddnskey.com" ];
    interval = "1min";
    usev6 = "no";
  };

}
