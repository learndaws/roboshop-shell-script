#\bin\bash

aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t2.micro --security-group-ids sg-01c0b35339d630515 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=testname}]'