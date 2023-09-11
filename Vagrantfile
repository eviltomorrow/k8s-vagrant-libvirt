ENV['VAGRANT_NO_PARALLEL']='yes'
# number of worker nodes
NUM_NODES=2
# number of extra disks per worker
NUM_DISKS=1
# size of each disk in gigabytes
DISK_GBS=20

MASTER_IP="192.168.133.100"
NODE_IP_BASE="192.168.133.2" # 200, 201, ...
TOKEN="abcdef.0123456789abcdef"
VM_BOX="debian/bookworm64"

Vagrant.configure("2") do |config|
  # config.nfs.functional = false
  # config.nfs.verify_installed = false
  # config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.box = VM_BOX
  config.vm.provision "shell", path: "sh/bootstrap.sh"

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 2048
    libvirt.cpus = 2
  end
  

  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: MASTER_IP
    (1..NUM_DISKS).each do |j|
      master.vm.provider :libvirt do |libvirt|
        libvirt.storage :file, :size => "#{DISK_GBS}G"
      end
    end
    master.vm.provision "shell", path: "sh/master.sh",
      env: { "MASTER_IP" => MASTER_IP, "TOKEN" => TOKEN }

  end

  (1..NUM_NODES).each do |i|
    config.vm.define "node0#{i}" do |node|
      node.vm.hostname = "node0#{i}"
      node.vm.network "private_network", ip: "#{NODE_IP_BASE}" + i.to_s.rjust(2, '0')
      (1..NUM_DISKS).each do |j|
        node.vm.provider :libvirt do |libvirt|
          libvirt.storage :file, :size => "#{DISK_GBS}G"
        end
      end
      node.vm.provision "shell", path: "sh/node.sh",
        env: { "MASTER_IP" => MASTER_IP, "TOKEN" => TOKEN }
    end
  end
end