# copy from hcl2/source-qemu.pkr.hcl
# (or not found)

source "qemu" "x86_64" {
  accelerator    = "kvm"
  boot_wait      = "5s"
  disk_interface = "virtio"
  disk_size      = "2000M"
  format         = "qcow2"
  http_directory = "http"
  iso_url        = "https://repo-default.voidlinux.org/live/current/void-live-x86_64-20210930.iso"
  iso_checksum   = "sha256:45b75651eb369484e1e63ba803a34e9fe8a13b24695d0bffaf4dfaac44783294"
  ssh_password   = "void"
  ssh_timeout    = "20m"
  ssh_username   = "void"
}

# partial copy from hcl2/build-cloud-generic.pkr.hcl
build {
  name = "cloud-generic-x86_64-musl"

  source "source.qemu.x86_64" {
    boot_command = [
      "<tab><wait>",
      "auto autourl=http://{{.HTTPIP}}:{{.HTTPPort}}/x86_64-musl.cfg",
      "<enter>"
    ]
    vm_name          = "voidlinux-x86_64-musl"
    output_directory = "cloud-generic-x86_64-musl"
  }

  provisioner "shell" {
    script          = "scripts/cloud.sh"
    execute_command = "echo 'void' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
  }
}

