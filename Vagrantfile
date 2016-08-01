# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define 'linux', primary: true do |lnx|
    lnx.vm.box = 'ubuntu/trusty64'
    lnx.vm.provision 'shell', keep_color: true, inline: <<-SHELL
      sudo apt-add-repository ppa:brightbox/ruby-ng -y
      sudo apt-get update
      sudo apt-get install ruby2.3 ruby2.3-dev build-essential zlib1g-dev software-properties-common -y
      gem install bundler
    SHELL
  end

  config.vm.define 'windows' do |win|
    win.vm.box = 'opentable/win-8-pro-amd64-nocm'
    win.vm.provider('virtualbox') { |v| v.gui = true }
    win.vm.synced_folder '.', 'C:/vagrant/'
  end
end
