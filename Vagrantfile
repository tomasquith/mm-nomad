# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.define 'linux' do |linux|
    linux.vm.network :private_network, ip: '192.168.56.101'

    linux.vm.provider :virtualbox do |v|
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      v.customize ['modifyvm', :id, '--memory', 2048]
      v.customize ['modifyvm', :id, '--name', 'nomad-linux']
    end

    linux.vm.box = 'bento/ubuntu-16.04'
    linux.vm.hostname = 'nomad-linux'
    linux.vm.provision 'shell', path: './scripts/linux.sh', privileged: false
    linux.vm.provision 'docker'

    linux.vm.network 'forwarded_port', guest: 4646, host: 4646, auto_correct: true
    linux.vm.network 'forwarded_port', guest: 8000, host: 8000, auto_correct: true
    linux.vm.network 'forwarded_port', guest: 8500, host: 8500, auto_correct: true

    linux.vm.synced_folder "jobs", "/jobs"
  end

  config.vm.define 'windows' do |windows|
    windows.vm.box = 'gusztavvargadr/w16s'
    windows.vm.hostname = 'windows-nomad'

    windows.vm.network :private_network, ip: '192.168.56.102'

    windows.vm.provider :virtualbox do |v|
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      v.customize ['modifyvm', :id, '--memory', 2048]
      v.customize ['modifyvm', :id, '--name', 'windows-nomad']
    end

    windows.vm.network 'forwarded_port', guest: 4646, host: 4647, auto_correct: true
    windows.vm.network 'forwarded_port', guest: 8000, host: 8001, auto_correct: true
    windows.vm.provision 'shell', path: './scripts/windows.ps1'
  end
end