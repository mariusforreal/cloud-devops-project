# استدعاء module الشبكة
module "network" {
  source = "./modules/network" # مسار module الشبكة

  project_name = var.project_name
  vpc_cidr     = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.10.0/24"
}

# استدعاء module السيرفرات (Jenkins Master and Slave)
module "server" {
  source = "./modules/server" # مسار module السيرفرات

  project_name         = var.project_name
  key_pair_name        = var.key_pair_name
  ami_id               = var.ami_id
  master_instance_type = var.master_instance_type
  slave_instance_type  = var.slave_instance_type

  vpc_id                = module.network.vpc_id
  public_subnet_id      = module.network.public_subnet_id
  private_subnet_id     = module.network.private_subnet_id
}
