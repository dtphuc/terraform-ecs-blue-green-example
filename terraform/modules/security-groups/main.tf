/*
# Create initial security groups
*/

# Get ID of created the Security Group
locals {
  this_sg_id = concat(
    aws_security_group.this.*.id,
    [""],
  )[0]
}

# Security group with name
resource "aws_security_group" "this" {
  count = var.create_security_groups ? 1 : 0

  name                   = var.sec_groups_name
  description            = var.sec_groups_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge(
    {
      "Name" = format("%s", var.sec_groups_name)
    },
    var.tags,
  )
}

/*
# Ingress - List of rules
*/
# Security group rules with "cidr_blocks" and it uses list of rules names

resource "aws_security_group_rule" "ingress_rules" {
  count = var.create_security_groups ? length(var.ingress_rules) : 0

  type              = "ingress"
  security_group_id = local.this_sg_id
  from_port         = lookup(var.ingress_rules[count.index], "from_port")
  to_port           = lookup(var.ingress_rules[count.index], "to_port")
  protocol          = lookup(var.ingress_rules[count.index], "protocol")
  cidr_blocks       = var.ingress_cidr_blocks
  description       = lookup(var.ingress_rules[count.index], "description")
}

/*
# Ingress - Maps of rules
*/
# Security group rules with "source_security_group_id"

resource "aws_security_group_rule" "ingress_with_source_security_group_id" {
  count = var.create_security_groups ? length(var.ingress_with_source_security_group_id) : 0

  type                     = "ingress"
  security_group_id        = local.this_sg_id
  from_port                = lookup(var.ingress_with_source_security_group_id[count.index], "from_port")
  to_port                  = lookup(var.ingress_with_source_security_group_id[count.index], "to_port")
  protocol                 = lookup(var.ingress_with_source_security_group_id[count.index], "protocol")
  description              = lookup(var.ingress_with_source_security_group_id[count.index], "description", "")
  source_security_group_id = lookup(var.ingress_with_source_security_group_id[count.index], "source_security_group_id")
}

resource "aws_security_group_rule" "ingress_with_self" {
  count = var.create_security_groups ? length(var.ingress_with_self) : 0

  type              = "ingress"
  security_group_id = local.this_sg_id
  from_port         = lookup(var.ingress_with_self[count.index], "from_port")
  to_port           = lookup(var.ingress_with_self[count.index], "to_port")
  protocol          = lookup(var.ingress_with_self[count.index], "protocol")
  description       = lookup(var.ingress_with_self[count.index], "description", "")
  self              = lookup(var.ingress_with_self[count.index], "self", true)
}

# End of ingress
#################

##################################
# Egress - List of rules (simple)
##################################
# Security group rules with "cidr_blocks" and it uses list of rules names
resource "aws_security_group_rule" "egress_rules" {
  count = var.create_security_groups ? length(var.egress_rules) : 0

  type              = "egress"
  security_group_id = local.this_sg_id
  from_port         = lookup(var.egress_rules[count.index], "from_port")
  to_port           = lookup(var.egress_rules[count.index], "to_port")
  protocol          = lookup(var.egress_rules[count.index], "protocol")
  cidr_blocks       = var.egress_cidr_blocks
  description       = lookup(var.egress_rules[count.index], "description")
}

#########################
# Egress - Maps of rules
#########################
# Security group rules with "source_security_group_id"
resource "aws_security_group_rule" "egress_with_source_security_group_id" {
  count = var.create_security_groups ? length(var.egress_with_source_security_group_id) : 0

  type                     = "egress"
  security_group_id        = local.this_sg_id
  from_port                = lookup(var.egress_with_source_security_group_id[count.index], "from_port")
  to_port                  = lookup(var.egress_with_source_security_group_id[count.index], "to_port")
  protocol                 = lookup(var.egress_with_source_security_group_id[count.index], "protocol")
  description              = lookup(var.egress_with_source_security_group_id[count.index], "description", "")
  source_security_group_id = lookup(var.egress_with_source_security_group_id[count.index], "source_security_group_id")
}

resource "aws_security_group_rule" "egress_with_self" {
  count = var.create_security_groups ? length(var.egress_with_self) : 0

  type              = "egress"
  security_group_id = local.this_sg_id
  self              = lookup(var.egress_with_self[count.index], "self", true)
  from_port         = lookup(var.egress_with_self[count.index], "from_port")
  to_port           = lookup(var.egress_with_self[count.index], "to_port")
  protocol          = lookup(var.egress_with_self[count.index], "protocol")
  description       = lookup(var.egress_with_self[count.index], "description", "")
}

################
# End of egress
################