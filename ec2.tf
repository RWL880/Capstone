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

  # ================== initial docker setup for all devices ==================

  provisioner "file" {
    source      = "docker.sh"
    destination = "/home/ubuntu/docker.sh"
  }

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
