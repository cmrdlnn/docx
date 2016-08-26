# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version '>= 1.8.3'

Vagrant.configure(2) do |config|
  config.vm.define 'linux', primary: true do |lnx|
    lnx.vm.box = 'ubuntu/trusty64'
    lnx.vm.provision :ansible_local do |ansible|
      ansible.playbook = '/vagrant/cm/vagrant.yml'
    end
  end

  config.vm.define 'windows', autostart: false do |win|
    win.vm.box = 'opentable/win-8-pro-amd64-nocm'
    win.vm.provider('virtualbox') { |v| v.gui = true }
    win.vm.synced_folder '.', 'C:/vagrant/'
  end
end
