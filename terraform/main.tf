

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
  key_pair    = openstack_compute_keypair_v2.DbKeyName.name
  network { 
    port = openstack_networking_port_v2.vpc.id
    
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
  key_pair    = openstack_compute_keypair_v2.GestautKeyName.name
  network { 
    port = openstack_networking_port_v2.vpc.id
    
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
  key_pair    = openstack_compute_keypair_v2.ESKeyName.name
  network { 
    port = openstack_networking_port_v2.vpc.id
    
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
  key_pair    = openstack_compute_keypair_v2.EdiKeyName.name
  network { 
    port = openstack_networking_port_v2.vpc.id
    
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
}# Subnet
resource "openstack_networking_subnet_v2" "subnet2_subnet" {
  name            = "subnet2_subnet"
  network_id      = openstack_networking_network_v2.vpc.id
  cidr            = "10.100.2.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.8.4"]
}# Subnet
resource "openstack_networking_subnet_v2" "subnet3_subnet" {
  name            = "subnet3_subnet"
  network_id      = openstack_networking_network_v2.vpc.id
  cidr            = "10.100.3.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.8.4"]
}

# Attach networking port
resource "openstack_networking_port_v2" "vpc" {
  name           = "concrete_vpc"
  network_id     = openstack_networking_network_v2.vpc.id
  admin_state_up = true
  security_group_ids = [
  
  ]
  # fixed_ip { ## TODO to be fixed (not working for posidonia example, needed for openstack example)
  #  subnet_id = openstack_networking_subnet_v2.vpc_subnet.id
  #}
}

# Create router
resource "openstack_networking_router_v2" "vpc_router" {
  name                = "vpc_router"
  external_network_id = data.openstack_networking_network_v2.external.id    #External network id
}
# Router interface configuration
resource "openstack_networking_router_interface_v2" "vpc_router_interface" {
  router_id = openstack_networking_router_v2.vpc_router.id
  # subnet_id = openstack_networking_subnet_v2.vpc_subnet.id ## TODO to be fixed (not working for posidonia example, needed for openstack example)
}



# Create ssh keys
resource "openstack_compute_keypair_v2" "DbKeyName" {
  name       = "oracledb"
  # public_key = "oracledb"
}



# Create ssh keys
resource "openstack_compute_keypair_v2" "GestautKeyName" {
  name       = "gestaut"
  # public_key = "gestaut"
}



# Create ssh keys
resource "openstack_compute_keypair_v2" "ESKeyName" {
  name       = "es"
  # public_key = "es"
}



# Create ssh keys
resource "openstack_compute_keypair_v2" "EdiKeyName" {
  name       = "edi"
  # public_key = "edi"
}

