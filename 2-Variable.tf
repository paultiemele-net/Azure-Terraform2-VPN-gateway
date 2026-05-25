# RG Central US

variable "resource_group_name" {
  default = "RG-CUS"
}

variable "location" {
  default = "Central US"
}


# RG North Central US

variable "resource_group_name2" {
  default = "RG-NCUS"
}

variable "location2" {
  default = "North Central US"
}

#VM Authentication

variable "admin_username" {
  default = "ptiemele"
}

variable "admin_password" {
  sensitive = true
}

#VM names

variable "vm_names" {
  default = [
    "VM-FE1",
    "VM-FE2",
    "VM-BE1-1",
    "VM-BE1-2",
    "VM-BE2-1",
    "VM-BE2-2"
  ]
}

variable "vm_names_ncus" {
  default = [
    "VM-NCUS-FE1",
    "VM-NCUS-FE2",
    "VM-NCUS-BE1-1",
    "VM-NCUS-BE1-2",
    "VM-NCUS-BE2-1",
    "VM-NCUS-BE2-2"
  ]
}
