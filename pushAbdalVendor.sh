#!/bin/sh

# TODO: DO A CHECK IF THERE'S UPDATES IN THE SCRIPTS THAT SHOULD BE PULLED
# TODO: ADD FLAGS AND ERROR HANDLING

# cd to abdal directory
cd C:/laragon/www/abdal

# check which branch you are on
brach=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo "************ You are on branch $brach ************"

# todo >> exit if you are not on vendor related branch

# restore mix config file back to original
git restore "C:\laragon\www\abdal\webpack.mix.js"

echo "************ Restore mix config file back to original ************"

if [[ $(git diff --exit-code) ]]; then
    # git add changes
    git add .
else
    echo -e "\n >>> no unstaged changes found \n"
fi

if [[ $(git diff --cached --exit-code) ]]; then
    # git commit changes
    echo -e "\n >>> Enter a commit message for your changes:"
    read commitMessage
    git commit -m "$commitMessage"
else
    echo -e "\n >>> no changes to be committed \n"
fi

# pull changes from dev/vendor branch
git checkout dev/vendor && git pull origin dev/vendor

# pull changes from dev/vendor-front & merge changes from dev/vendor branch to dev/vendor-front branch
git checkout dev/vendor-front && git pull origin dev/vendor-front && git merge dev/vendor

echo "************ Merge changes from dev/vendor branch to dev/vendor-front branch ************"

# if previous branch is not dev/vendor-front, then merge changes from previous branch to dev/vendor-front branch
if [ "$branch" != "dev/vendor-front" ]; then
    git checkout dev/vendor-front && git merge "$branch"
fi

echo "************ Merge changes from previous branch to dev/vendor-front branch ************"

# push changes to origin dev/vendor-front branch
git push origin dev/vendor-front

echo "📦 Changes have been pushed to dev/vendor-front branch successfully."
