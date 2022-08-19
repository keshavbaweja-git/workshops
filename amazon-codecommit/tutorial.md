# Tutorial
```
# 1. Create a CodeCommit repository named data-lake-etl-jobs
mkdir ~/git-base
cd ~/git-base
aws codecommit create-repository --repository-name data-lake-etl-jobs

# 2. Clone CodeCommit repository
git clone ssh://git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/data-lake-etl-jobs


# 3. Clone aws-glue-samples repository from github
cd ~/git-base
git clone --mirror git@github.com:aws-samples/aws-glue-samples.git

# 4. Push aws-glue-samples to CodeCommit repo data-lake-etl-jobs
cd ~/git-base/aws-glue-samples.git
git push --all ssh://git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/data-lake-etl-jobs

# 5. Pull data-lake-etl-jobs from CodeCommit
cd ~/git-base/data-lake-etl-jobs
git pull

# 6. Rename master branch to main
git checkout master
git branch -m master main
git push -u origin main
git branch -vv

# 7. Delete master branch
git push origin --delete master

# 8. Create develop branch
git checkout -b develop
git branch -vv
git push -u origin develop
git branch -vv

# 9. Create .gitignore file
cat > .gitignore <<EOF
**/target/
EOF

git status
git add --all
git commit -m "Added .gitignore"
git push
```
                       
# Command reference
```
# Check local repo status
git status

# Add all tracked and untraced files to Staging
git add --all

# Add all tracked and untraced files to Staging - Dry Run
git add --all -n

# Restore from Staging area to Working Directory
git restore --staged .

# Commit staged changes to local repo
git commit -m "commit message"

# Revert the latest commit from local repo (not published to remote repo)
# Changes are moved to Staging
git reset --soft HEAD~1

# Revert the latest commit from local repo (not published to remote repo)
# Changes are moved to Working Dir
git reset HEAD~1

# Revert the latest commit from local repo (not published to remote repo)
# Changes are lost
git reset --hard HEAD~1

# Show current branch
git branch --show-current

# Show local branches
git branch -vv

# Show all (local and remote) branches
git branch -a

# Fetch updates from remote branch without merging into local branch
git fetch

# Fetch updates from remote branch and merge into local branch
git pull
```
