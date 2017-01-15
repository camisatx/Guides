#OpenVPN on Docker

OpenVPN server in a Docker container complete with an EasyRSA PKI CA.

[GitHub](https://github.com/kylemanna/docker-openvpn)

[Digital Ocean Ubuntu 14.04 Guide](https://www.digitalocean.com/community/tutorials/how-to-run-openvpn-in-a-docker-container-on-ubuntu-14-04)

##Install Options

You can setup the container using either a [docker-compose script](#using-docker-compose) or [individual docker run commands](#using-docker-run-commands).


###Using docker-compose

#####Server Configuration

Make sure you have this docker-compose.yml file in the current directory:
```yamlex
version: '2.1'

services:
  openvpn:
    image: kylemanna/openvpn
    volumes:
      - ovpn_data:/etc/openvpn
    ports:
      - "1194:1194/udp"
    restart: always
    cap_add:
      - NET_ADMIN

volumes:
  ovpn_data:
    external: false
```

Initialize the configuration files. Change `VPN.SERVERNAME.COM` to your domain name.
```bash
docker-compose run --rm openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM -C 'AES-256-CBC' -a 'SHA384'
docker-compose run -e EASYRSA_KEY_SIZE=4096 --rm openvpn ovpn_initpki
```

Start the OpenVPN container:
```bash
docker-compose up -d openvpn
```

#####Client Keys
Generate a client certificate with 2048 bit RSA keys and no password:
```bash
docker-compose run --rm openvpn easyrsa build-client-full CLIENTNAME nopass
```
Alternatively, generate a client certificate with 4096 bit RSA keys:
```bash
docker-compose run -e EASYRSA_KEY_SIZE=4096 --rm openvpn easyrsa build-client-full CLIENTNAME
```

Retrieve the client configuration with embedded certificate:
```bash
docker-compose run --rm openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn
```

[Source](https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md)


###Using docker run commands

#####Server Configuration
Create a persistent data volume called `ovpn-data`:
```bash
docker volume create --name "ovpn-data"
```

Initialize the configuration files, linking to the ovpn-data volume. Change `VPN.SERVERNAME.COM` to your domain name.
```bash
docker run -v "ovpn-data":/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM -C 'AES-256-CBC' -a 'SHA384'
docker run -e EASYRSA_KEY_SIZE=4096 -v "ovpn-data":/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
```

Start the OpenVPN container:
```bash
docker run -v "ovpn-data":/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
```

#####Client Keys
Generate a client certificate with 2048 bit RSA keys and no password:
```bash
docker run -v "ovpn-data":/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full CLIENTNAME nopass
```
Alternatively, generate a client certificate with 4096 bit RSA keys:
```bash
docker run -e EASYRSA_KEY_SIZE=4096 -v "ovpn-data":/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full CLIENTNAME
```

Retrieve the client configuration with embedded certificate:
```bash
docker run -v "ovpn-data":/etc/openvpn --rm kylemanna/openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn
```

[Source](https://github.com/kylemanna/docker-openvpn)


##OpenVPN on Alternate Ports

To make OpenVPN only use TCP port 443:
```bash
docker run -v "ovpn-data":/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u tcp://VPN.SERVERNAME.COM:443
docker run -v "ovpn-data":/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
docker run -v "ovpn-data":/etc/openvpn -d -p 443:1194/tcp --cap-add=NET_ADMIN kylemanna/openvpn
```

Or create a second fallback container just for TCP 443 connections:
```bash
docker run -v "ovpn-data":/etc/openvpn --rm -p 443:1194/tcp --privileged kylemanna/openvpn ovpn_run --proto tcp
```

[Source](https://github.com/kylemanna/docker-openvpn/blob/master/docs/tcp.md)
