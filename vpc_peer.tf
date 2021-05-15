#VPC 1
resource "aws_vpc" "us-east" {
  provider = aws.region-1
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "VPC-1"
  }
}

#IG 1
resource "aws_internet_gateway" "gw-east" {
  vpc_id = aws_vpc.us-east.id
  tags = {
      Name = "VPC-1"
  }
}

#Subnets 1-1
resource "aws_subnet" "main-east" {
  vpc_id     = aws_vpc.us-east.id
  cidr_block = "10.0.1.0/24"
  tags = {
      Name = "VPC-1"
  }

}

#Subnets 1-2
resource "aws_subnet" "secondary-east" {
  vpc_id     = aws_vpc.us-east.id
  cidr_block = "10.0.2.0/24"
  tags = {
      Name = "VPC-1"
  }

}

#VPC 2
resource "aws_vpc" "us-west" {
  provider = aws.region-2  
  cidr_block = "172.16.0.0/16"
  tags = {
      Name = "VPC-2"
  }
}

#IG 2
resource "aws_internet_gateway" "gw-west" {
  vpc_id = aws_vpc.us-west.id
}

#Subnet 2-1
resource "aws_subnet" "main-west" {
  vpc_id     = aws_vpc.us-west.id
  cidr_block = "172.16.1.0/24"
  tags = {
      Name = "VPC-2"
  }

}

#Subnet 2-2
resource "aws_subnet" "secondary-west" {
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
  auto_accept = false

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