##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "vdc-${terraform.workspace}-vpc"

  cidr = "${var.aws_network_address_space}"
  azs = "${slice(data.aws_availability_zones.available.names,0,var.aws_subnet_count)}"
  private_subnets = ["${var.aws_subnet1_address_space}"]
  public_subnets = ["${var.aws_subnet2_address_space}"]

  enable_nat_gateway = false

  create_database_subnet_group = false

  
  tags {
    Environment = "${terraform.workspace}"
    Name = "2-demo-vpc"
  }
}
