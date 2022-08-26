

//add policies that are the same for every environment
module "env_policies" {
  source   = "./modules/policies/common"
  for_each = toset(var.secret_env_list)
  env      = each.key
}
