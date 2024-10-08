# ================== create ec2 instances ==================

resource "aws_instance" "vm1" {
  count                  = 3
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.nkp.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id              = aws_subnet.sn1.id
  tags = {
    "Name" = "Team-1-Capstone-${count.index}"
  }
  associate_public_ip_address = true

  # ================== Copy docker/ansible install file on all devices ==================

  provisioner "file" {
    source      = "docker_ansible.sh"
    destination = "/home/ubuntu/docker_ansible.sh"
  }

  # ================== Copy docker/ansible install file on all devices ==================

  provisioner "file" {
    source      = "playbooks"
    destination = "/home/ubuntu/playbooks"
  }

  # ================== Copy dockerfiles contents ==================

  provisioner "file" {
    source      = "dockerfiles"
    destination = "/home/ubuntu/playbooks/dockerfiles"
  }

  # ================== Mod permissions and run docker/ansible install on all devices ==================

    provisioner "remote-exec" {
    inline = [
      "sudo chmod a+x /home/ubuntu/docker_ansible.sh",
      "sudo mkdir /home/ubuntu/playbooks",
      "sudo chmod a+x /home/ubuntu/playbooks/*",
      "sudo chmod a+x /home/ubuntu/playbooks/dockerfiles/*",
      "sudo mkdir /home/ubuntu/php", 
      "sudo chmod a+x /home/ubuntu/php",
      "sudo cp /home/ubuntu/playbooks/dockerfiles/index.php /home/ubuntu/php/index.php",
      "sudo bash /home/ubuntu/docker_ansible.sh",
    ]
  }


  # ================== SSH connection for file/remote exec actions ==================

    connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = var.privatekey
    timeout     = "3m"
  }
}

output "PublicIpAddress" {
  value = aws_instance.vm1.*.public_ip
}
