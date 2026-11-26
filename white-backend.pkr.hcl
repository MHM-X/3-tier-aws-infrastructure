
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.0"
    }

    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.0"
    }
  }
}

source "amazon-ebs" "white_backend" {
  # AWS configuration
  profile       = "dev"
  region        = "eu-north-1"
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"

  vpc_id                      = "vpc-03ef9104ddfea7b1f"
  subnet_id                   = "subnet-03d99c9163f6ed576"
  associate_public_ip_address = true

  iam_instance_profile = "white-packer-build-role"

  # Use the Ubuntu AMI provided by you
  source_ami = "ami-021aaf3749be66813"

  # Output AMI
  ami_name        = "white-backend-{{timestamp}}"
  ami_description = "White backend image prepared with Ansible and Docker"

  # Restrict Packer's temporary SSH security group to the
  # public IP of the machine running Packer.
  temporary_security_group_source_public_ip = true

  # Allow time for Ubuntu to boot and SSH to become available.
  ssh_timeout = "10m"

  # Root disk for the generated AMI
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  # AMI tags
  tags = {
    Name        = "white-backend"
    Project     = "White"
    Environment = "production"
    ManagedBy   = "Packer"
  }
}

build {
  name    = "white-backend"
  sources = ["source.amazon-ebs.white_backend"]

  provisioner "ansible" {
    # Replace this with the actual path to your Ansible playbook.
    playbook_file = "/mnt/c/Users/LENOVO/ansible/playbook.yml"

    user = "ubuntu"

    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]

    extra_arguments = [
      "--become"
    ]
  }
}
