# Distributed-Threatfeed v3

Only one nginx web server is provided in this version. This web server does not download or upload data anywhere.

Here, the index.html file is processed via a second container using a Visual Studio Code Web View. There is also no whitelist in this version. But HTTP-basic-Auth is still available.

Simply download all the files and create the container:

```sh
docker build -t distributed-threatfeed .
```

Important information: if IP addresses are changed, they are automatically replaced in the index.html file. 

Here is the compose script

```yaml
---
services:
  code-server:
    image: lscr.io/linuxserver/code-server:latest
    container_name: 02_Threatfeed_V3_code-server
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
      - PASSWORD=password
 #     - HASHED_PASSWORD= #optional
      - SUDO_PASSWORD=password
 #     - SUDO_PASSWORD_HASH= #optional
 #     - PROXY_DOMAIN=code-server.my.domain #optional
      - DEFAULT_WORKSPACE=/website
    volumes:
      - /docker/02_Threatfeed_v3/config-vscode:/config
      - /docker/02_Threatfeed_v3/website:/website
    ports:
      - 8443:8443
    restart: unless-stopped
    networks:
      disthred-nw:
        ipv4_address: 172.18.3.11


  web-server:
    container_name: 02_Threatfeed_v3
    image: schefflerit/distributed-threatfeed:v3
    restart: unless-stopped
    environment:
      - BASIC_AUTH=true
      - BASIC_AUTH_USER=myuser
      - BASIC_AUTH_PASSWORD=mypassword
    volumes:
      - /docker/02_Threatfeed_v3/website:/var/www/html
    ports:
      - "8742:80"
    networks:
      disthred-nw:
        ipv4_address: 172.18.3.12

networks:
  disthred-nw:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.3.0/24
          gateway: 172.18.3.1
```
