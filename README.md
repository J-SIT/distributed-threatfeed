# Distributed-Threatfeed v2

This project is about setting up a web server that displays IP addresses from a GitHub repository.
There is also a whitelist so that only authorised sources can access the information provided.

In my case, malicious IP addresses are stored in a GitHub repository file with the name index.html in the format 200.12.13.14/32. We then specify this web server as the source in our FortiGates. Of course, this also works with other firewalls. 

I used an Alpine Linux, installed nginx git and openssl and then loaded the data from GitHub using a script.

We created a GitHub DeployKey so that the private repository can be retrieved. (GitHub repository settings --> Deploy keys)

```sh
ssh-keygen -t ed25519 -C "deploy-key" -f ./id_deploy_key -N ""
```

Simply download all the files and create the container:

```sh
docker build -t distributed-threatfeed .
```

Important information: if IP addresses are changed, they are automatically replaced in the index.html file. 

BUT if the whitelist is changed, the container must be restarted as the nginx config must be reloaded. I have not yet had the time to automatically integrate this into the container.

This is version 2 and an HTTP Basic Auth has been added. Since the nginx settings are also changed here, the container must be restarted in one way or another when making adjustments in order to load the new entries.

Here is the compose script

```yaml
version: '3.8'
services:
  nginx-github:
    container_name: 3_Distributed-Threatfeed_v2
    image: schefflerit/distributed-threatfeed:latest
    restart: unless-stopped
    environment:
      - GITHUB_URL=git@github.com:YOUR-USERNAME/YOUR-REPOSITORY.git
      - INDEX_FILE=index.html
      - WHITELIST_FILE=whitelist.txt
      - UPDATE_INTERVAL=60
      - BASIC_AUTH=true
      - BASIC_AUTH_USER=myuser
      - BASIC_AUTH_PASSWORD=mypassword
    volumes:
      - /docker/03_threadfeed/id_deploy_key:/root/.ssh/id_rsa
    ports:
      - "8741:80"
    networks:
      disthred-nw:
        ipv4_address: 172.18.3.11

networks:
  disthred-nw:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.3.0/24
          gateway: 172.18.3.1
```
