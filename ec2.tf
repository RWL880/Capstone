# ================== create ec2 instances ==================

resource "aws_instance" "vm1" {
  count                  = 3
  ami                    = "ami-0583d8c7a9c35822c"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.nkp.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id              = aws_subnet.sn1.id
  tags = {
    "Name" = "Team-1-Capstone-${count.index}"
  }
  associate_public_ip_address = true
}

output "PublicIpAddress" {
  value = aws_instance.vm1.*.public_ip
}



