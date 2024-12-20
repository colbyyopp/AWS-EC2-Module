/*======= EC2 Instance =======*/
variable "ami" {
  description = "AMI to be used. Recommended to use data lookup"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}

variable "availability_zone" {
  description = "AZ to start the instance in; Also used for EBS volumes"
  type        = string
  default = null
}

variable "key_name" {
  description = "Key pair to use for EC2 instances"
  type        = string
  default     = null
}

variable "user_data" {
  description = "Path to where user data is stored. Variables can be added if using templatefile function"
  default = ""
}

variable "use_internal_eni" {
  description = "Whether to use dedicated network interfaces or not."
  type        = bool
  default     = true
}

variable "vpc_security_group_ids" {
  description = "Security group utilized by the instance"
  default     = ""
}

variable "subnet_id" {
  description = "Private subnet to pull from manual configuration or VPC module"
  default     = ""
}

variable "associate_public_ip_address" {
  description = "whether or not to associate a public IP to the instance"
  type        = bool
  default     = null #was false but conflicts with another resource
}

variable "private_ip" {
  description = "Private IP to associate with the instance"
  default     = null
}

variable "disable_api_termination" {
  description = "Keeps instances from being manually terminated"
  type        = bool
  default     = true
}

variable "disable_api_stop" {
  description = "Keeps instances from being manually stopped"
  type        = bool
  default     = false
}

variable "hibernation" {
  description = "If true, the instance will support hibernation"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance"
  type        = string
  default     = "stop"
}

variable "ebs_optimized" {
  description = "If true, launched instance will be EBS optimized, prioritizing IOPS for EBS volumes; some instances(particularly large ones) have this enabled by default; enabling this will charge an additional hourly fee"
  type        = bool
  default     = null
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the dest address doesn't match the instance. Used for NAT or VPNs"
  type        = bool
  default     = null #was true but conflicts with another resource
}

variable "iam_instance_profile" {
  description = "Instance profile to apply to instances. Commonly pulled from the ssm-connect module"
  default     = null
}

variable "monitoring" {
  description = "Enables detailed monitoring for the instance"
  type        = bool
  default     = true
}



/*====== Root Block Device =======*/
variable "delete_on_termination" {
  description = "Whether or not the volume is destroyed when the instance is terminated"
  type        = bool
  default     = true
}

variable "volume_type" {
  description = "Type of volume used for the block device"
  type        = string
}

variable "volume_size" {
  description = "Size of the volume in GiB"
  type        = number
}

variable "kms_key_id" {
  description = "ARN of the KMS key used for EBS"
}



/*====== Tags =======*/
variable "name" {
  description = "Name included in the the instance tags"
  type        = string
}

variable "tags" {
  description = "Custom tags to apply to the instance; Dynamic so more can be added as needed"
  default = []
}



/*====== Launch Template =======*/
variable "launch_template" {
  default = null
}

/*====== Metadata Options =======*/
variable "metadata_options" {
  default = null
}



/*====== Primary ENI =======*/
variable "eni_subnet_id" {
}
variable "eni_private_ips" {
  default = null
}
variable "eni_security_groups" {
}
variable "eni_tags" {
}

/*====== Additional ENIs =======*/
variable "eni_additional" {
  default = null
}

/*====== EBS =======*/
variable "ebs_volumes" {
  description = "List of additional EBS volumes to attach"
  default     = {}
}

/*====== EIP =======*/
variable "eip" {
  description = "List of EIPs to create"
  default     = {}
}