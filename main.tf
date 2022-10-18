
module "vpc" {
  source = "./VPC"
  vpc_id = module.vpc.vpc_id
  subnet_id_1 = module.vpc.subnet_id_1
  subnet_id_2 = module.vpc.subnet_id_2
  sg_id = module.vpc.sg_id
}

module "auto_scaling" {
  source = "./VM"
  vpc_id = module.vpc.vpc_id
  subnet_id_1 = module.vpc.subnet_id_1
  subnet_id_2 = module.vpc.subnet_id_2
  sg_id = module.vpc.sg_id
  
}

