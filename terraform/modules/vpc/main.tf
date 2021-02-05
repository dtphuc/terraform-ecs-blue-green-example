/*
#  Create AWS VPC
*/

resource "aws_vpc" "vpc" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.aws_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = var.aws_vpc_name
    Environment = var.aws_environment
    Comment     = var.aws_description
  }

  # New replacement object is created first, and then the prior object is destroyed only once the replacement is created.
  lifecycle {
    create_before_destroy = true
  }
}

/*
# Create AWS Internet Gateway
*/

resource "aws_internet_gateway" "aws_internet_gateway" {
  vpc_id = aws_vpc.vpc[0].id

  tags = {
    Name        = "${var.aws_vpc_name}-gw"
    Environment = var.aws_environment
    Comment     = var.aws_description
    Type        = "Internet Gateway"
  }

  lifecycle {
    create_before_destroy = true
  }
}

/*
# Create public subnets in AZ
*/

resource "aws_subnet" "public_subnet" {
  count                   = length(var.aws_availability_zones)
  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = element(var.public_subnet_cidr_all, count.index)
  availability_zone       = element(var.aws_availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format("${var.aws_vpc_name}-public-sub-%d", count.index +1)
      "Description" = var.aws_description
    },
    var.tags,
    var.public_subnet_tags,
  )
}

/*
# Create private subnets in AZ
*/

resource "aws_subnet" "private_subnet" {
  count             = var.create_private_subnet && length(var.aws_availability_zones) > 0 ? length(var.aws_availability_zones) : 0
  vpc_id            = aws_vpc.vpc[0].id
  cidr_block        = element(var.private_subnet_cidr_all, count.index)
  availability_zone = element(var.aws_availability_zones, count.index)

  tags = merge(
    {
      "Name" = format("${var.aws_vpc_name}-private-sub-%d", count.index +1)
      "Description" = var.aws_description
    },
    var.tags,
    var.private_subnet_tags,
  )
}

/*
# Add Route Table for Public Subnets.
*/

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_internet_gateway.id
  }

  tags = {
    Name        = "${var.aws_vpc_name}-public-rtb"
    Environment = var.aws_environment
    Commnet     = var.aws_description
  }

  lifecycle {
    ignore_changes = [route]
  }
}

/*
# Add Route table association for Public Subnets.
*/

resource "aws_route_table_association" "public_route_table" {
  count          = length(var.aws_availability_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

# Create NAT Gateway
resource "aws_eip" "eip_nat_gateway" {
  count = var.create_private_subnet && length(var.aws_availability_zones) > 0 ? length(var.aws_availability_zones) : 0
  vpc   = true

  tags = {
    Name        = format("${var.aws_vpc_name}-nat-gw-%d", count.index + 1)
    Environment = var.aws_environment
    Comment     = var.aws_description
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_private_subnet && length(var.aws_availability_zones) > 0 ? length(var.aws_availability_zones) : 0
  allocation_id = element(aws_eip.eip_nat_gateway.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    Name        = format("${var.aws_vpc_name}-nat-gw-%d", count.index + 1)
    Environment = var.aws_environment
    Comment     = var.aws_description
    Type        = "NAT Gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  count  = var.create_private_subnet && length(var.aws_availability_zones) > 0 ? length(var.aws_availability_zones) : 0
  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  }

  tags = {
    Name = format("${var.aws_vpc_name}-private-rtb-%d", count.index + 1)
    Environment = var.aws_environment
    Comment     = var.aws_description
  }
  lifecycle {
    ignore_changes = [route]
  }
}

/*
# Add Route table association for Private Subnets.
*/
resource "aws_route_table_association" "private_subnet_table" {
  count          = var.create_private_subnet && length(var.aws_availability_zones) > 0 ? length(var.aws_availability_zones) : 0
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}

