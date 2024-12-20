#########################
#       Instance        #
#########################
resource "aws_instance" "this" {
  ami                                  = var.ami
  instance_type                        = var.instance_type
  availability_zone                    = var.availability_zone
  key_name                             = var.key_name
  user_data                            = base64encode(var.user_data)
  associate_public_ip_address          = var.associate_public_ip_address
  private_ip                           = var.private_ip
  disable_api_termination              = var.disable_api_termination
  disable_api_stop                     = var.disable_api_stop
  hibernation                          = var.hibernation
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  ebs_optimized                        = var.ebs_optimized
  source_dest_check                    = var.source_dest_check
  iam_instance_profile                 = var.iam_instance_profile
  monitoring                           = var.monitoring

  root_block_device {
    delete_on_termination = var.delete_on_termination
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    kms_key_id            = var.kms_key_id
    encrypted             = true
  }

  tags = merge({ "Name" = upper(var.name) }, var.tags)

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []

    content {
      name    = launch_template.value.template_name
      version = launch_template.value.template_version
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []

    content {
      http_tokens   = metadata_options.value.http_tokens
      http_endpoint = metadata_options.value.http_endpoint
    }
  }
}

#########################
#          ENI          #
#########################
resource "aws_network_interface" "primary" {
  subnet_id       = var.eni_subnet_id
  private_ips     = var.eni_private_ips
  security_groups = var.eni_security_groups
  tags            = merge({"Name" = upper("${var.name}-ENI")}, var.eni_tags)
}

resource "aws_network_interface_attachment" "primary" {
  instance_id = aws_instance.this.id
  network_interface_id = aws_network_interface.primary.id
  device_index = 0
}

resource "aws_network_interface" "additional" {
  for_each = var.eni_additional

  subnet_id       = each.value.subnet_id
  private_ips     = each.value.private_ips
  security_groups = each.value.security_groups
  tags            = merge({"Name" = upper("${var.name}-ENI")}, each.value.tags)
}

resource "aws_network_interface_attachment" "additional" {
  for_each = var.eni_additional

  instance_id          = aws_instance.this.id
  network_interface_id = aws_network_interface.additional[each.key].id
  device_index         = each.value.device_index
}

#########################
#          EBS          #
#########################
resource "aws_ebs_volume" "this" {
  for_each = var.ebs_volumes

  availability_zone = var.availability_zone
  size              = each.value.size
  encrypted         = each.value.encrypted
  type              = each.value.type
  kms_key_id        = each.value.kms_key_id
}

resource "aws_volume_attachment" "this" {
  for_each = var.ebs_volumes

  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.this[each.key].id
  instance_id = aws_instance.this.id
}

#########################
#          EIP          #
#########################
resource "aws_eip" "this" {
  for_each = var.eip

  domain                    = each.value.domain
  network_interface         = aws_network_interface.primary.id
  associate_with_private_ip = each.value.associate_with_private_ip

  tags = each.value.tags
}