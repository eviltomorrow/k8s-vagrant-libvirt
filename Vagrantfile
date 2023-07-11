ENV['VAGRANT_NO_PARALLEL'] = 'yes'
# number of worker nodes
NUM_NODES = 2
# number of extra disks per worker
NUM_DISKS = 1
# size of each disk in gigabytes
DISK_GBS = 20

MASTER_IP = "192.168.133.100"
WORKER_IP_BASE = "192.168.133.2" # 200, 201, ...
# TOKEN = "yi6muo.4ytkfl3l6vl8zfpk"

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"
  # config.vm.synced_folder ".", "/vagrant", disabled: true
  # config.vm.provision "shell", path: "setup-env.sh"
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpu_mode = 'host-passthrough'
    # libvirt.graphics_type = 'none'
    libvirt.memory = 2048
    libvirt.cpus = 2
    libvirt.qemu_use_session = false
  end


  # config.vm.provision "shell", path: "local-storage/create-volumes.sh"

  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: MASTER_IP
    # master.vm.provision "shell", path: "master.sh",
      # env: { "MASTER_IP" => MASTER_IP, "TOKEN" => TOKEN }

    # master.vm.provision :file do |file|
    #   file.source = "local-storage/storageclass.yaml"
    #   file.destination = "/tmp/local-storage-storageclass.yaml"
    # end
    # master.vm.provision :file do |file|
    #   file.source = "local-storage/provisioner.yaml"
    #   file.destination = "/tmp/local-storage-provisioner.yaml"
    # end
    # 
  end

  # (1..NUM_NODES).each do |i|
  #   config.vm.define "node0#{i}" do |node|
  #     node.vm.hostname = "node0#{i}"
  #     node.vm.network "private_network", ip: "#{WORKER_IP_BASE}" + i.to_s.rjust(2, '0')
  #     (1..NUM_DISKS).each do |j|
  #       node.vm.provider :libvirt do |libvirt|
  #         libvirt.storage :file, :size => "#{DISK_GBS}G"
  #       end
  #     end
  #     # node.vm.provision "shell", path: "worker.sh",
  #       # env: { "MASTER_IP" => MASTER_IP, "TOKEN" => TOKEN }
  #   end
  # end
end