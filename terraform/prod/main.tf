provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

data "terraform_remote_state" "state" {
  backend = "gcs"

  config {
    bucket = "${var.bucket}"
  }
}

module "app" {
  source           = "../modules/app"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  zone             = "${var.zone}"
  app_disk_image   = "${var.app_disk_image}"
  db_ip            = "${module.db.db_internal_ip}"
  need_provision   = "${var.need_provision}"
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["46.148.194.254/32"]
}
