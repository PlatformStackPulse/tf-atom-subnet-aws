resource "aws_subnet" "this" {
  count = module.this.enabled ? 1 : 0

  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(module.this.tags, { Name = module.this.id })
}
