aws iam attach-role-policy \
--role-name ecsInstanceRole \
--policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role

aws iam attach-role-policy \
--role-name ecsInstanceRole \
--policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore