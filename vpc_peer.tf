#VPC 1
resource "aws_vpc" "us-east" {
  provider = aws.region-1
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "VPC-1"
  }
}

#VPC 2
resource "aws_vpc" "us-west" {
  provider = aws.region-2  
  cidr_block = "172.31.0.0/16"
  tags = {
      Name = "VPC-2"
  }
}


#Peering
resource "aws_vpc_peering_connection" "us-east-west-peer" {
  peer_vpc_id   = aws_vpc.us-west.id
  vpc_id        = aws_vpc.us-east.id
  peer_region   = "us-west-1"
  auto_accept = false

  tags = {
      Name = "us-east-west-peer"
  }
}

resource "aws_vpc_peering_connection_accepter" "eastwest-accept-peer" {
  provider                  = aws.region-2
  vpc_peering_connection_id = aws_vpc_peering_connection.us-east-west-peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}