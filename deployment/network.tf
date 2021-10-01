resource "aws_vpc" "ytrd_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "ytrd_public_a" {
  vpc_id            = aws_vpc.ytrd_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
}

# Don't need this for now as it's for redundancy in multiple AZ's
#
# resource "aws_subnet" "ytrd_public_b" {
#   vpc_id = "${aws_vpc.ytrd_test_vpc.id}"
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "${var.aws_region}b"
# }

resource "aws_internet_gateway" "ytrd_default_igw" {
  vpc_id = aws_vpc.ytrd_vpc.id

  tags = {
      Name = "ytrd_public_igw"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.ytrd_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ytrd_default_igw.id
}

resource "aws_security_group" "ytrd_secgroup" {
  name        = "ytrd_secgroup"
  description = "Allow http inbound traffic on port 80"
  vpc_id      = aws_vpc.ytrd_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
