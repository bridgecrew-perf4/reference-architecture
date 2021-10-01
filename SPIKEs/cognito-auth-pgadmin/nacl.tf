resource "aws_network_acl" "main" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = concat(aws_subnet.public_subnet.*.id, aws_subnet.private_subnet.*.id)
  tags = {
    Name = "${local.pool_name}-main-acl"
  }
}
resource "aws_network_acl_rule" "ingress_ipv4" {
  count          = length(local.ipv4_acl_ingress_rules)
  network_acl_id = aws_network_acl.main.id
  egress         = false
  cidr_block     = local.ipv4_acl_ingress_rules[count.index].cidr_block
  protocol       = local.ipv4_acl_ingress_rules[count.index].protocol
  rule_number    = local.ipv4_acl_ingress_rules[count.index].rule_number
  rule_action    = local.ipv4_acl_ingress_rules[count.index].action
  from_port      = local.ipv4_acl_ingress_rules[count.index].from_port
  to_port        = local.ipv4_acl_ingress_rules[count.index].to_port
}
resource "aws_network_acl_rule" "egress_ipv4" {
  count          = length(local.ipv4_acl_egress_rules)
  network_acl_id = aws_network_acl.main.id
  egress         = true
  cidr_block     = local.ipv4_acl_egress_rules[count.index].cidr_block
  protocol       = local.ipv4_acl_egress_rules[count.index].protocol
  rule_number    = local.ipv4_acl_egress_rules[count.index].rule_number
  rule_action    = local.ipv4_acl_egress_rules[count.index].action
  from_port      = local.ipv4_acl_egress_rules[count.index].from_port
  to_port        = local.ipv4_acl_egress_rules[count.index].to_port
}
