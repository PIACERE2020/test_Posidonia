

terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  insecure    = true
}

# Retrieve data
data "openstack_networking_network_v2" "external" {
  name = "external"
}


# Create virtual machine
resource "openstack_compute_instance_v2" "OracleDB" {
  name        = "concrete_oracle_db"
  image_name  = "Ubuntu-Focal-20.04-Daily-2022-04-19"
  flavor_name = "small"
  key_pair    = openstack_compute_keypair_v2.user1.name
  network { 
    port = openstack_networking_port_v2.net1_1.id
    
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "OracleDB_floating_ip" {
  pool = "external"
  # fixed_ip = ""
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "OracleDB_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.OracleDB_floating_ip.address
  instance_id = openstack_compute_instance_v2.OracleDB.id
}



# Create virtual machine
resource "openstack_compute_instance_v2" "gestaut_vm" {
  name        = "concrete_gestaut_vm"
  image_name  = "Ubuntu-Focal-20.04-Daily-2022-04-19"
  flavor_name = "small"
  key_pair    = openstack_compute_keypair_v2.user1.name
  network { 
    port = openstack_networking_port_v2.net1_2.id
    
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "gestaut_vm_floating_ip" {
  pool = "external"
  # fixed_ip = ""
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "gestaut_vm_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.gestaut_vm_floating_ip.address
  instance_id = openstack_compute_instance_v2.gestaut_vm.id
}



# Create virtual machine
resource "openstack_compute_instance_v2" "elasticsearch_vm" {
  name        = "elasticsearch_vm"
  image_name  = "Ubuntu-Focal-20.04-Daily-2022-04-19"
  flavor_name = "small"
  key_pair    = openstack_compute_keypair_v2.user1.name
  network { 
    port = openstack_networking_port_v2.net1_3.id
    
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "elasticsearch_vm_floating_ip" {
  pool = "external"
  # fixed_ip = ""
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "elasticsearch_vm_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.elasticsearch_vm_floating_ip.address
  instance_id = openstack_compute_instance_v2.elasticsearch_vm.id
}

# Create virtual machine
resource "openstack_compute_instance_v2" "edi_vm" {
  name        = "edi_vm"
  image_name  = "Ubuntu-Focal-20.04-Daily-2022-04-19"
  flavor_name = "small"
  key_pair    = openstack_compute_keypair_v2.user1.name
  network { 
    port = openstack_networking_port_v2.net1_4.id
    
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "edi_vm_floating_ip" {
  pool = "external"
  # fixed_ip = ""
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "edi_vm_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.edi_vm_floating_ip.address
  instance_id = openstack_compute_instance_v2.edi_vm.id
}


## Network

## Network

# Create Network
resource "openstack_networking_network_v2" "vpc" {
  name = "concrete_vpc"
}

# Subnet
resource "openstack_networking_subnet_v2" "subnet1_subnet" {
  name            = "subnet1_subnet"
  network_id      = openstack_networking_network_v2.vpc.id
  cidr            = "10.100.1.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.8.4"]
}

# Create Network
resource "openstack_networking_network_v2" "net1" {
  name = "concrete_net"
}

# Attach networking port
resource "openstack_networking_port_v2" "net1_1" {
  name           = "port1_1"
  network_id     = openstack_networking_network_v2.vpc.id
  admin_state_up = true
  security_group_ids = [
  openstack_compute_secgroup_v2.nginx.id,
  ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet1_subnet.id
  }
}

resource "openstack_networking_port_v2" "net1_2" {
  name           = "port1_2"
  network_id     = openstack_networking_network_v2.vpc.id
  admin_state_up = true
  security_group_ids = [
  openstack_compute_secgroup_v2.nginx.id,
  ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet1_subnet.id
  }
}

resource "openstack_networking_port_v2" "net1_3" {
  name           = "port1_3"
  network_id     = openstack_networking_network_v2.vpc.id
  admin_state_up = true
  security_group_ids = [
  openstack_compute_secgroup_v2.nginx.id,
  ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet1_subnet.id
  }
}

resource "openstack_networking_port_v2" "net1_4" {
  name           = "port1_4"
  network_id     = openstack_networking_network_v2.vpc.id
  admin_state_up = true
  security_group_ids = [
  openstack_compute_secgroup_v2.nginx.id,
  ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet1_subnet.id
  }
}
# Create router
resource "openstack_networking_router_v2" "net1_router" {
  name                = "net1_router"
  external_network_id = data.openstack_networking_network_v2.external.id    #External network id
}
# Router interface configuration
resource "openstack_networking_router_interface_v2" "net1_router_interface" {
  router_id = openstack_networking_router_v2.net1_router.id
  subnet_id = openstack_networking_subnet_v2.subnet1_subnet.id
}

# generate random string
resource "random_string" "key_pair_user_name" {
  length           = 16
  special          = false
  upper            = false
  numeric          = false
}

# Create ssh keys
resource "openstack_compute_keypair_v2" "user1" {
  name       = random_string.key_pair_user_name.result
  # public_key = "oracledb"
}

# CREATING SECURITY_GROUP
  
resource "openstack_compute_secgroup_v2" "nginx" {
  name        = "nginx"
  description  = "Security group rule for nginx"
  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}