provider "oci" {
  auth = "InstancePrincipal"
  region = "${var.region}"
}


// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.


variable "region" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {}

variable "shape_name" {
  default = "VM.Standard2.1"
}
variable "subnet_ocid" {
 
}
variable "instance_image_ocid" {
  type = "map"

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaoqj42sokaoh42l76wsyhn3k2beuntrh5maj3gmgmzeyr55zzrwwa"

    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaitzn6tdyjer7jl34h2ujz74jwy5nkbukbh55ekp6oyzwrtfa4zma"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaa32voyikkkzfxyo4xbdmadc2dmvorfxxgdhpnk6dw64fa3l4jh7wa"
  }
}
variable "ad" {}


tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaajehugl3ryss2gaxf3os7g5w4xdztfhy4coqnoizm2wpmrclnv5da"
region="us-ashburn-1"
compartment_ocid="ocid1.compartment.oc1..aaaaaaaa3pkequhrpjjdqd4i7ldhs6piblz2hiadbk5i3juy3xautlmzypxa"
ssh_public_key="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAwsLOjrH+ukEk72AW5hUvyAMf+J6ES8vC3uFglIFK6SkcvsAFHkoYrHJoJmxRGe3Fwo9WmnwgxqMbhA0gEnBFP6IhxwNgWxSkB0M1uTCLNJ4WXlYKoXwh50GelBsRcryzuzDchCXm7kA4U0/KzD4KPMb+KveDmArRugLEK4gS8TDJBGCCSTOrYOhvQb/s7qkrDOT+rQDhYs+C/kmBPbs/XwJsOUiQi4crUamYqPyq71oWGBnXBUEi6qWnywwchOAT1VRRpT+I/hlx8HZt03EZy/Fvl+86sMISoDXN9mgL3D5xZJNCFw8iKzmPUr+HMsoNW8Hlf5B6+hmNH0GPotqHrw== rsa-key-20191127"
ad="2"
subnet_ocid="ocid1.subnet.oc1.iad.aaaaaaaayjvjkvacz3e6kyk4cuqtdfw42bjhkmac7jlz4xrhau4h7tq2roaa"
shape_name="VM.Standard2.1"


// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

data "oci_identity_availability_domain" "ad" {
  compartment_id = "${var.tenancy_ocid}"
  ad_number      = "${var.ad}"
}

// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

resource "oci_core_instance" "TFInstance" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "mytfinstance"
  shape               = "${var.shape_name}"
  create_vnic_details {
    subnet_id        = "${var.subnet_ocid}"
    display_name     = "primaryvnic"
    assign_public_ip = true
   // hostname_label   = "${var.hostname_label}"
  }
 

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid[var.region]}"

    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    boot_volume_size_in_gbs = "60"
  }

  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true

  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key)}"
  }
}
// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

# Output the private and public IPs of the instance
output "InstancePrivateIPs" {
  value = ["${oci_core_instance.TFInstance.*.private_ip}"]
}

output "InstancePublicIPs" {
  value = ["${oci_core_instance.TFInstance.*.public_ip}"]
}


