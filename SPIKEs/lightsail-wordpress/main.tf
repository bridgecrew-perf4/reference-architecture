resource "aws_lightsail_instance" "wordpress" {
  name              = "WordpressLightsailTest"
  availability_zone = "us-east-1a"
  blueprint_id      = "wordpress"
  bundle_id         = "nano_2_0"
  key_pair_name     = "LightsailDefaultKeyPair"
#  tags = {
#    foo = "bar"
#  }
}

# Does not support Import
resource "aws_lightsail_static_ip_attachment" "wordpress" {
  static_ip_name = aws_lightsail_static_ip.wordpress.id
  instance_name  = aws_lightsail_instance.wordpress.id
}

# Does not support Import
resource "aws_lightsail_static_ip" "wordpress" {
  name = "WordpressTest"
}
