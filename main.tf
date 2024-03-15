terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./AWS_VPC"
  cidr_block = "192.168.0.0/16"
  cidr_block_public_subnet= ["192.168.1.0/24", "192.168.2.0/24"]
  azs = ["ap-south-1a", "ap-south-1b"]

}

module "security_group" {
  source = "./Security_group"
  vpc_id = module.vpc.vpc_id

}

module "aws_lb" {
  source = "./AWS_lb"
  name = "aws-lb"
  subnets = module.vpc.subnet
  security_groups = [module.security_group.security_group_id]
  target_type = "instance"
  vpc_id = module.vpc.vpc_id
}

module "asg" {
  source = "./AWS_ASG"
  iamge_id = "ami-0253000eaaef5fbc5"
  depends_on = [ module.aws_lb ]
  instance_type = "t2.micro"
  asg_name = "asg_for_project"
  alb_arn = module.aws_lb.target_group_arn
  min_size = 0
  max_size = 1
  desired_capacity = 1
  health_check_type = "EC2"
  load_balancer = module.aws_lb.lb_id
  security_group_id = module.security_group.security_group_id
  subnet = module.vpc.subnet
  user_data = filebase64("./userdata.sh")
  target_group_arn = module.aws_lb.target_group_arn
  keyname = "projectKey"
}

module "ecs" {
  source = "./AWS_ECS"
  image_url = "730335487196.dkr.ecr.ap-south-1.amazonaws.com/project_repo:latest"
  min_capacity=1
  task_name="project_task_definition"
  max_capacity = 2
  cpu = 301
  memory = 300
  backend_image_url = "730335487196.dkr.ecr.ap-south-1.amazonaws.com/project_repo_dotnet:latest"
  backend_task_name = "dotnet_app"
  
}