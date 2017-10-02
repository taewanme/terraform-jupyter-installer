provider "opc" {
  user            = "${var.user}"
  password        = "${var.password}"
  identity_domain = "${var.domain}"
  endpoint        = "${var.endpoint}"
}

resource "opc_compute_ssh_key" "sshkey4jupyter" {
  name    = "sshkey.jupyter"
  key     = "${file(var.ssh_public_key_file)}"
  enabled = true
}

resource "opc_compute_ip_reservation" "ipreser_jupyter" {
  parent_pool = "/oracle/public/ippool"
  permanent   = true
}

resource "opc_compute_instance" "jupyter" {
  name       = "jupyter"
  label      = "jupyter"
  shape      = "oc3"
  image_list = "/oracle/public/OL_7.2_UEKR4_x86_64"
  ssh_keys   = ["${opc_compute_ssh_key.sshkey4jupyter.name}"]

  networking_info {
    index          = 0
    shared_network = true
    nat            = ["${opc_compute_ip_reservation.ipreser_jupyter.name}"]
    sec_lists      = ["${opc_compute_security_list.jupyter_list.name}"]
  }

  connection {
    type        = "ssh"
    host        = "${opc_compute_ip_reservation.ipreser_jupyter.ip}"
    user        = "opc"
    private_key = "${file(var.ssh_private_key_file)}"
    timeout     = "15m"
  }

  provisioner "file" {
   # upload the example configuration
   source      = "files/"
   destination = "/home/opc"
  }

  provisioner "remote-exec" {
   inline = [
     "chmod +x /home/opc/script.sh",
     "/home/opc/script.sh",
   ]
  }
}

resource "opc_compute_security_list" "jupyter_list" {
  name                 = "jupyter_list"
  policy               = "DENY"
  outbound_cidr_policy = "PERMIT"
}

resource "opc_compute_security_application" "jupyter" {
  name     = "jupyter-8888"
  protocol = "tcp"
  dport    = "8888"
}

resource "opc_compute_security_application" "tensorboard" {
  name     = "tensorboard"
  protocol = "tcp"
  dport    = "8008"
}

resource "opc_compute_sec_rule" "jupyter-http" {
  name             = "Allow-Jupyter-http-access"
  source_list      = "seciplist:/oracle/public/public-internet"
  destination_list = "seclist:${opc_compute_security_list.jupyter_list.name}"
  action           = "permit"
  application      = "${opc_compute_security_application.jupyter.name}"
  disabled         = false
}

resource "opc_compute_sec_rule" "tensorboard-http" {
  name             = "Allow-Tensorboard-http-access"
  source_list      = "seciplist:/oracle/public/public-internet"
  destination_list = "seclist:${opc_compute_security_list.jupyter_list.name}"
  action           = "permit"
  application      = "${opc_compute_security_application.tensorboard.name}"
  disabled         = false
}

resource "opc_compute_sec_rule" "jupyter-ssh" {
  name             = "Allow-Jupyter-ssh-access"
  source_list      = "seciplist:/oracle/public/public-internet"
  destination_list = "seclist:${opc_compute_security_list.jupyter_list.name}"
  action           = "permit"
  application      = "/oracle/public/ssh"
  disabled         = false
}

output "ssh" {
  value = "ssh -i ${var.ssh_private_key_file} opc@${opc_compute_ip_reservation.ipreser_jupyter.ip}"
}

output "jupyter_url" {
  value = "http://${opc_compute_ip_reservation.ipreser_jupyter.ip}:${opc_compute_security_application.jupyter.dport}"
}

output "tensorborac_url" {
  value = "http://${opc_compute_ip_reservation.ipreser_jupyter.ip}:${opc_compute_security_application.tensorboard.dport}"
}
