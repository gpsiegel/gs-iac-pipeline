#VPC 1
resource "aws_vpc" "us-east" {
  provider             = aws.region-1
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-1"
  }
}

#IG 1
resource "aws_internet_gateway" "gw-east" {
  provider = aws.region-1
  vpc_id   = aws_vpc.us-east.id
  tags = {
    Name = "VPC-1"
  }
}

#AZs
data "aws_availability_zones" "azs-1" {
  provider = aws.region-1
  state    = "available"
}


#Subnets 1-1
resource "aws_subnet" "main-east" {
  provider          = aws.region-1
  vpc_id            = aws_vpc.us-east.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = element(data.aws_availability_zones.azs-1.names, 0)
  tags = {
    Name = "VPC-1"
  }

}

#Subnets 1-2
resource "aws_subnet" "secondary-east" {
  provider          = aws.region-1
  vpc_id            = aws_vpc.us-east.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = element(data.aws_availability_zones.azs-1.names, 1)
  tags = {
    Name = "VPC-1"
  }

}

#VPC 2
resource "aws_vpc" "us-west" {
  provider             = aws.region-2
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-2"
  }
}


#IG 2
resource "aws_internet_gateway" "gw-west" {
  provider = aws.region-2
  vpc_id   = aws_vpc.us-west.id
  tags = {
    Name = "VPC-2"
  }
}

#Subnet 2-1
resource "aws_subnet" "main-west" {
  provider   = aws.region-2
  vpc_id     = aws_vpc.us-west.id
  cidr_block = "172.16.1.0/24"
  tags = {
    Name = "VPC-2"
  }

}

#Subnet 2-2
resource "aws_subnet" "secondary-west" {
  provider   = aws.region-2
  vpc_id     = aws_vpc.us-west.id
  cidr_block = "172.16.2.0/24"
  tags = {
    Name = "VPC-2"
  }
}

data "aws_caller_identity" "current" {}

#Peering
resource "aws_vpc_peering_connection" "us-east-west-peer" {
  peer_vpc_id   = aws_vpc.us-west.id
  vpc_id        = aws_vpc.us-east.id
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_region   = "us-west-1"
  auto_accept   = false

  tags = {
    Name = "us-east-west-peer"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.region-2
  vpc_peering_connection_id = aws_vpc_peering_connection.us-east-west-peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

#us-east-1 Route Table
resource "aws_route_table" "east-rt" {
  provider = aws.region-1
  vpc_id   = aws_vpc.us-east.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-east.id
  }
  route {
    cidr_block                = "172.16.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.us-east-west-peer.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "VPC1-RT"
  }
}

resource "aws_main_route_table_association" "east-default-rt" {
  provider       = aws.region-1
  vpc_id         = aws_vpc.us-east.id
  route_table_id = aws_route_table.east-rt.id
}

#us-west-1 Route Table
resource "aws_route_table" "west-rt" {
  provider = aws.region-2
  vpc_id   = aws_vpc.us-west.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-west.id
  }
  route {
    cidr_block                = "10.0.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.us-east-west-peer.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "VPC2-RT"
  }
}

#default us-west-1 rt
resource "aws_main_route_table_association" "west-default-rt" {
  provider       = aws.region-2
  vpc_id         = aws_vpc.us-west.id
  route_table_id = aws_route_table.west-rt.id
}