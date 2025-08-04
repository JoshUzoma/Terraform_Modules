organization  = "htown"
team          = "sp"
resource_type = "vpce"
purpose       = "Rockets"
env           = "dev"
aws_region    = "us-east-2"

vpc_id = ""

subnet_ids = [
  "",
  ""
]

security_group_ids = [
  ""
]

endpoint_type = "Gateway"

service_name = "com.amazonaws.us-east-2.s3"

private_dns_enabled = true

policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOF