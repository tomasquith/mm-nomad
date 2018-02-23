# Nomad Cluster across Windows and Linux

This is a PoC configuration to get a nomad cluster spanning Windows Server 2016 Standard and Ubuntu 1604. It bootstraps nomad automatically using consul.

TODO - Overlay network...

## Prerequisites

Virtualbox 5.2.6+
Vagrant 2.0.2+

## Getting Started

```bash
vagrant up
# Windows needs to be rebooted for docker to configure.
vagrant reload windows

# if you need to get on the servers:
vagrant ssh linux
# install RDP client first! (username: vagrant, password: vagrant)
vagrant rdp windows 
```

## Accessing User Interfaces from Host

http://192.168.56.101:8500/ui/#/dc1/services
http://192.168.56.101:4646/ui/

## Sample Jobs

You'll find a selection of job files in the /jobs directory.

These can be run using synced folder by using the following command:

```bash
vagrant ssh linux -c "sudo nomad plan /jobs/<filename>"
vagrant ssh linux -c "sudo nomad run /jobs/<filename>"
```

They can also be run using the API, but I wrote them in HCL rather than JSON... you can convert a job file to it's API friendly json using the following command:

```bash
vagrant ssh linux -c "sudo nomad run -output /jobs/<filename>"
```
