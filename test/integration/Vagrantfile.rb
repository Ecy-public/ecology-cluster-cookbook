Vagrant.configure(2) do |config|
  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['storagectl', :id, '--name', 'SCSI Controller', '--add', 'scsi', '--controller', 'LSILogic', '--portcount', '16']
    (0...4).each do |i|
      unless File.exist?("machine1_disk#{i}.vdi")
        vb.customize ['createhd', '--filename', "machine1_disk#{i}", '--size', '1024']
      end
      vb.customize ['storageattach', :id, '--storagectl', 'SCSI Controller', '--port', "#{i+1}", '--type', 'hdd', '--medium', "machine1_disk#{i}.vdi", '--device', '0']
    end
  end
end
