# ================== create keys ==================

resource "aws_key_pair" "nkp" {
  key_name   = "rob-key-pair"
  public_key = var.publickey
}