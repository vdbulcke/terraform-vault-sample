

//add policies that are the same for every environment
module "common_policies" {
  source   = "./modules/policies/common"
  for_each = toset(["dev", "acc", "prod"])
  env      = each.key
}
