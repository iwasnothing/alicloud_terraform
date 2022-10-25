module "image_import" {
  source = "../modules/image_import_module"

  for_each = var.image_list

  name     = each.value.name
  arch     = each.value.arch
  platform = each.value.platform
  size     = each.value.size
  bucket   = each.value.bucket
  file     = each.value.file
}
