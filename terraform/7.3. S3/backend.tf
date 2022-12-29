terraform {
 backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "test-mybucket-netology"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    # access_key = "YCAJEMf-g3JP1RBUWbhjJMGE5"
    # secret_key = "YCO86TH_oTNCsVWKV-03VNzg4vzfE9q5pwkmKSQK"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}