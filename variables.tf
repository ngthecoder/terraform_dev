variable "host_os" {
    description = "Host OS (linux or windows)"
    type = string
    default = "linux"
}

variable "home_ip" {
    description = "Home IP address"
    type = string
}

variable "ssh_public_path" {
    description = "Path to SSH Public Key"
    type = string
}

variable "ssh_private_path" {
    description = "Path to SSH Private Key"
    type = string
}