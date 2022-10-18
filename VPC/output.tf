output "vpc_id" {
  value = aws_vpc.customVPC.id
}

output "subnet_id_1" {
  value = aws_subnet.pub-a.id
}

output "subnet_id_2" {
  value = aws_subnet.pub-b.id
}

output "sg_id" {
  value = aws_security_group.instance.id
}



