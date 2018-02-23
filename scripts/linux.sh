#!/bin/bash

# Update apt and get dependencies
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y unzip curl vim \
apt-transport-https \
ca-certificates \
software-properties-common

echo "Fetching Java..."
sudo apt-get install openjdk-8-jre -y
#sudo update-alternatives --config java

# Consul/Nomad versions
NOMAD_VERSION=0.7.1
CONSUL_VERSION=1.0.3

echo "Fetching Nomad..."
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip

echo "Fetching Consul..."
curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > consul.zip

sudo ufw disable

echo "Installing Nomad..."
unzip nomad.zip
sudo install nomad /usr/bin/nomad

sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d

echo "Installing Consul..."

sudo mkdir -p /etc/consul.d/{data,logs,conf}

sudo tee -a /etc/consul.d/conf/client.json <<EOF
{
    "bootstrap": true,
    "bootstrap_expect": 1,
    "server": true,
    "datacenter": "dc1",
    "data_dir": "/etc/consul.d/data",
    "encrypt": "X4SYOinf2pTAcAHRhpj7dA==",
    "log_level": "INFO",
    "enable_syslog": false,
    "bind_addr": "192.168.56.101",
    "ui": true,
    "client_addr": "127.0.0.1 192.168.56.101"
}
EOF

unzip /tmp/consul.zip
sudo install consul /usr/bin/consul
sudo tee -a /etc/systemd/system/consul.service <<EOF
	[Unit]
	Description=consul agent
	Requires=network-online.target
	After=network-online.target
	
	[Service]
	Restart=on-failure
	ExecStart=/usr/bin/consul agent -config-dir /etc/consul.d/conf
	ExecReload=/bin/kill -HUP $MAINPID
	
	[Install]
	WantedBy=multi-user.target
EOF

sudo systemctl enable consul.service
sudo systemctl start consul

for bin in cfssl cfssl-certinfo cfssljson
do
	echo "Installing $bin..."
	curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
	sudo install /tmp/${bin} /usr/local/bin/${bin}
done

sudo mkdir -p /etc/nomad.d/{data,logs,conf}

sudo tee -a /etc/nomad.d/conf/server.hcl <<EOF
datacenter = "dc1"
data_dir   = "/etc/nomad.d/data"

addresses {
  http = "0.0.0.0"
  rpc  = "192.168.56.101"
  serf = "192.168.56.101" # non-default ports may be specified
}

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true
  node_class = "linux"
}
EOF

sudo tee -a /etc/systemd/system/nomad-agent.service <<EOF
	[Unit]
	Description=nomad agent
	Requires=network-online.target
	After=network-online.target
	
	[Service]
	Restart=on-failure
	ExecStart=/usr/bin/nomad agent -config=/etc/nomad.d/conf/server.hcl
	ExecReload=/bin/kill -HUP $MAINPID
	
	[Install]
	WantedBy=multi-user.target
EOF

sudo systemctl enable nomad-agent.service
sudo systemctl start nomad-agent.service