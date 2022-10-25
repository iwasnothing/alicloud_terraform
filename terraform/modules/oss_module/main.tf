resource "alicloud_oss_bucket" "bucket" {
  bucket        = var.bucket
  acl           = var.acl
  storage_class = var.storage_class
}
