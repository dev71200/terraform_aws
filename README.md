# terraform_aws
Terraform code (with module) to create VPC,Autoscaling,LoadBalancer

-- Setup AWS Image with nginx installed
-- Setup AWS VPC, Public Subnet, Private Subnet, Internet Gateway, Security Group for EC2
-- Setup EC2 autoscaling, initial size 2 and scale up to 6. Scale out based if cpu goes above 70% and scale in if CPU is below 20%
-- Setup Load Balancer, where those EC2 instance will be used as backend.
-- The Ngnix page should be accessible using Load balancer
