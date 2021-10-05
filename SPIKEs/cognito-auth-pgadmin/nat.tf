resource "aws_eip" "eip" {
  count = local.is_single_nat_gateway ? 1 : length(local.cidr_public_subnet_blocks)
  tags = {
    Name = "${local.pool_name}-nat-${lookup(local.zone_map, count.index, null)}"
  }
}
resource "aws_nat_gateway" "nat" {
  count         = local.is_single_nat_gateway ? 1 : length(local.cidr_public_subnet_blocks)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "${local.pool_name}-nat-${lookup(local.zone_map, count.index, null)}"
  }
}
