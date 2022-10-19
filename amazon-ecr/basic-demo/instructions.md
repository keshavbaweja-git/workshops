## Build the Docker image
```
docker build -t hello-world .
```

## Verify the image build
```
docker images --filter reference=hello-world
```

## Run the image locally
```
docker run -ti -p 80:80 hello-world
```

## Authenticate to ECR
```
aws_account_id=$(aws sts get-caller-identity --query Account --output text)
region=ap-southeast-1
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $aws_account_id.dkr.ecr.$region.amazonaws.com
```

## Create a repository
```
aws ecr create-repository \
--repository-name hello-repository \
--image-scanning-configuration scanOnPush=true \
--region $region
```

## Tag and push the image
```
docker tag hello-world:latest $aws_account_id.dkr.ecr.$region.amazonaws.com/hello-repository
docker push $aws_account_id.dkr.ecr.$region.amazonaws.com/hello-repository
```