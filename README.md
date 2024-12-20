# Introduction 
This module creates an EC2 instance, ENIs, EIPs, and EBS volumes that associate to the instance being built. Launch_template and metadata_options inline instance blocks are optional. The primary ENI and Root Block Device are created and associated by default.

# Getting Started
Bare minimum required input data:
Ami
Instance_type
Availability_zone

Volume_type
Volume_size
kms_key_id

Eni_subnet_id
Eni_private_ips
Eni_security_groups
Eni_tags = {}

These are the optional resources(leave lists empty if not using):
Eni_additional = {}

# Example of Module in Use with all possible features and arguments 
NOTE: The version shown below if for demonstration purposes. Please check the registry for the latest version.  

Please use variables or locals rather than hardcoding if it makes sense. Hardcoded values shown for demonstration purposes.  

This module is also fully loopable if needed. In this case, this module is designed to be use with locals in order to customize different arguments.  

```
module "ec2" {
  source   = "api.env0.com/env0identifierhere/aws-ec2/ado"
	version = "1.0.0"

  ami                                  = "ami-1jh2g13kj23hj"
  instance_type                        = "t3.micro"
  availability_zone                    = "us-east-1a"
  key_name                             = null
  user_data                            = base64encode("./user_data")
  associate_public_ip_address          = null
  private_ip                           = null
  disable_api_termination              = true
  disable_api_stop                     = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  ebs_optimized                        = false
  source_dest_check                    = null
  iam_instance_profile                 = ""
  monitoring                           = true

  /*=== Root Block Device ===*/
  delete_on_termination = true
  volume_type           = "gp3"
  volume_size           = 50
  kms_key_id            = module.kms.key.arn

  /*====== Tags ======*/
  name = "test"
    tags = {
        ticket      = "testticket"
        role        = "testrole"
        application = "testapp"
        owner       = "testowner"
    }

  /*=== Launch Template ===*/
  launch_template = {
    template_name    = "test"
    template_version = 1
  }

  /*=== Metadata Options ===*/
  metadata_options = {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }



  /*====== ENI ======*/
  eni_subnet_id       = module.vpc.private_subnets["private_a"].subnet_id
  eni_private_ips     = []
  eni_security_groups = [module.security-group.sg_id["instance_asg"]]
  eni_tags = {
    Role        = "testrole"
    Ticket      = "testticket"
    Application = "testapp"
  }

  eni_additional = {
		test1 = {
      device_index = 1
      subnet_id       = module.vpc.private_subnets["private_a"].subnet_id
      private_ips     = []
      security_groups = [module.security-group.sg_id["instance_asg"]]
      tags = {
        Role        = "testrole"
        Ticket      = "testticket"
        Application = "testapp"
      }
		}	
	}

  /*====== EBS Volumes ======*/
  ebs_volumes = {
		test1 = {
      size              = 50
      encrypted         = true
      type              = "gp3"
      kms_key_id        = module.kms.key.arn
      device_name       = "/dev/xvdb"
    }
    test2 = {
      size              = 50
      encrypted         = true
      type              = "gp3"
      kms_key_id        = module.kms.key.arn
      device_name       = "/dev/xvdc"
    }
	}

  /*====== EIP ======*/
  eip = {
		test1 = {
      domain                    = "vpc"
      associate_with_private_ip = ""
      tags = {
        Name        = "testname"
        Role        = "testrole"
        Ticket      = "testticket"
        Application = "testapp"
      }
		}	
	}
}
```

# Imports
It's likely that imports for ENIs and EBS volumes will need to be done along with the moved blocks for the instances. Here's an an example of how the import blocks should look:
```
import {
  to = module.pam360_db["pam360_db"].aws_network_interface.primary
  id = "eni-98q7we765we76"
}

import {
  to = module.pam360_db["pam360_db"].aws_network_interface_attachment.primary
  id = "eni-attach-jh1g23jh1g23"
}

import {
  to = module.pam360_db["pam360_db"].aws_ebs_volume.this["xvdf"]
  id = "vol-jh1g23jh1g2"
}

import {
  to = module.pam360_db["pam360_db"].aws_volume_attachment.this["xvdf"]
  id = "xvdf:vol-kj1h23kj1h23:i-kj1h23kj1h23"
}
```

Output instance ID reference example:
module.domain_controllers.instance[each.key].id