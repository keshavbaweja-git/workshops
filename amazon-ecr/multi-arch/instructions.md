## Initialize the app
```
npm install
```

## Authenticate to ECR
```
aws_account_id=$(aws sts get-caller-identity --query Account --output text)
region=ap-southeast-1
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $aws_account_id.dkr.ecr.$region.amazonaws.com
```

## Create a repository
```
repository=multi-arch
aws ecr create-repository \
--repository-name multi-arch \
--image-scanning-configuration scanOnPush=true \
--region $region
```

## Build the Docker image
```
docker buildx build -t $aws_account_id.dkr.ecr.$region.amazonaws.com/multi-arch:amd64 --platform linux/amd64 .
docker buildx build -t $aws_account_id.dkr.ecr.$region.amazonaws.com/multi-arch:arm64 --platform linux/arm64 .
```

## Verify the image build
```
docker images --filter reference=$aws_account_id.dkr.ecr.$region.amazonaws.com/multi-arch:amd64
```

## Tag and push the image
```
docker push $aws_account_id.dkr.ecr.$region.amazonaws.com/multi-arch:amd64
docker push $aws_account_id.dkr.ecr.$region.amazonaws.com/multi-arch:arm64
```

## List images in ECR repository
```
aws ecr describe-images --repository-name multi-arch
```

## Create Docker manifest list
```
docker manifest create $aws_account_id.dkr.ecr.$region.amazonaws.com/multi-arch $aws_account_id.dkr.ecr.$region.amazonaws.com/multi-arch:amd64 $aws_account_id.dkr.ecr.$region.amazonaws.com/multi-arch:arm64
```

## Inspect Docker manifest list
```
docker manifest inspect $aws_account_id.dkr.ecr.$region.amazonaws.com/multi-arch
```

## Push Docker manifest list to ECR
```
docker manifest push $aws_account_id.dkr.ecr.$region.amazonaws.com/multi-arch
``` 