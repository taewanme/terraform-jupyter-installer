
variable user {
  type    = "string"
  default = ""
}

variable password {
  type    = "string"
  default = ""
}

variable domain {
  type    = "string"
  default = ""
}

variable endpoint {
  type    = "string"
  default = ""
}

variable ssh_public_key_file {
  description = "ssh public key"
  default     = ""
}

variable ssh_private_key_file {
  description = "ssh private key"
  default     = ""
}
