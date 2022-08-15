# 1. Create a CodeCommit repository named data-lake-etl-jobs
```
mkdir ~/git-base
cd ~/git-base
aws codecommit create-repository --repository-name data-lake-etl-jobs
```

# 2. Clone CodeCommit repository
```
git clone ssh://git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/data-lake-etl-jobs
```


# 3. Clone aws-glue-samples repository from github
```
cd ~/git-base
git clone --mirror git@github.com:aws-samples/aws-glue-samples.git
```

# 4. Push aws-glue-samples to CodeCommit repo data-lake-etl-jobs
```
cd ~/git-base/aws-glue-samples.git
git push --all ssh://git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/data-lake-etl-jobs
```

# 5. Pull data-lake-etl-jobs from CodeCommit
```
cd ~/git-base/data-lake-etl-jobs
git pull
```

# 6. Rename master branch to main
```
git checkout master
git branch -m master main
git push -u origin main
git branch -vv
```

# 7. Delete master branch
```
git push origin --delete master
```