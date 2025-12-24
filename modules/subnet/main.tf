resource "aws_subnet" "public" {
  for_each = zipmap(var.availability_zones, var.cidr_blocks)

  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = var.names[lookup(keys(var.availability_zones), each.key)]
  }
}
