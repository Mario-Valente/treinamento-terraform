variable "aws_iam_user"{
    type = string
    default = "teste_iam"
}
variable "cidr" {
  
  default = "10.0.0.0/24"
}

variable "name_vpc" {
    type = string
    default = "my_vpc"
  
}