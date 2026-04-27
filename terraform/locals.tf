locals {
  prefix = "${var.project}-${var.owner}"

  common_tags = {
    Project   = var.project
    Owner     = var.owner
    ManagedBy = "terraform"
  }
}
