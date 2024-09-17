# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Define variables
  box_name = "bento/ubuntu-22.04"
  vm_name = "ubuntu22"
  vm_ip = "192.168.10.90"
  vm_memory = "2048"
  vm_cpus = "4"
  secondary_disk_size = 10240 # in MB (10GB)
  secondary_disk_path = "D:/VMS/#{vm_name}/#{vm_name}_secondary.vdi"

  # Set the base box
  config.vm.box = box_name

  # Create a private network with a specific IP
  config.vm.network "private_network", ip: vm_ip

  # Provider-specific configuration
  config.vm.provider "virtualbox" do |vb|
    # Set the name of the VM dynamically
    vb.name = vm_name

    # Customize the amount of memory and CPUs on the VM
    vb.memory = vm_memory
    vb.cpus = vm_cpus

    # Video memory and 3D acceleration
    vb.customize ["modifyvm", :id, "--vram", "64"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]

    # Clipboard sharing
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]

    # Description for the VM
    vb.customize ["modifyvm", :id, "--description", "IP: #{vm_ip}"]

    # Set the bootable ordered list
    vb.customize [
      "modifyvm", :id, 
      "--boot1", "dvd",
      "--boot2", "disk"
    ]

    # Check if the secondary disk exists, then create and attach if not
    if !File.exist?(secondary_disk_path)
      vb.customize [
        "createhd", 
        "--filename", secondary_disk_path,
        "--size", secondary_disk_size
      ]

      vb.customize [
        "storageattach", :id, 
        "--storagectl", "SATA Controller",
        "--port", 1, 
        "--device", 0, 
        "--type", "hdd", 
        "--medium", secondary_disk_path
      ]
    else
      puts "Secondary disk already exists: #{secondary_disk_path}"
    end
  end

  # Provisioning with a shell script
  config.vm.provision "shell", path: "scripts/auto_partition_mount.sh"

end