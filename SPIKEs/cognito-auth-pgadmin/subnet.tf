resource "aws_subnet" "public_subnet" {
  count                   = length(local.cidr_public_subnet_blocks)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1${lookup(local.zone_map, count.index, null)}"
  cidr_block              = local.cidr_public_subnet_blocks[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.pool_name}-public-subnet-${lookup(local.zone_map, count.index, null)}"
  }
}
resource "aws_subnet" "private_subnet" {
  count                   = length(local.cidr_private_subnet_blocks)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1${lookup(local.zone_map, count.index, null)}"
  cidr_block              = local.cidr_private_subnet_blocks[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${local.pool_name}-private-subnet-${lookup(local.zone_map, count.index, null)}"
  }
}
