#!/bin/sh

# first, cd to abdal directory
cd C:/laragon/www/abdal;

# check which branch you are on
branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
echo "************ You are on branch $branch ************"

# todo >> exit if you are not on vendor related branch

# restore mix config file back to original
git restore "C:\laragon\www\abdal\webpack.mix.js"
echo "************ Restore mix config file back to original ************"


# git add changes & commit
# git add .
# echo ">>> Enter a commit message for your changes."
# read commitMessage
# git commit -m "$commitMessage"
# echo "************ Commit message\n { $commitMessage } ************"


# pull changes from dev/vendor-front & merge changes from dev/vendor branch to dev/vendor-front branch
git checkout dev/vendor && git pull origin dev/vendor;
git checkout dev/vendor-front && git pull origin dev/vendor-front && git merge dev/vendor;
echo "************ Merge changes from dev/vendor branch to dev/vendor-front branch ************"

git checkout swap-vendor && git pull origin swap-vendor && git merge dev/vendor-front;
echo "************ Pull changes from swap-vendor branch ************"

# push changes to origin dev/vendor-front branch
echo ">>> Do you want to checkout to vendor-front and merge swap-vendor into it? (y,n) default: (y)"
read $ask
if [ "$ask" != "n" ]; then
  git checkout dev/vendor-front & git merge swap-vendor;
  echo "📦 Changes have been merge from swap-vendor to dev/vendor-front branch successfully.";
fi
if [ "$ask" = "n" ]; then
  echo "************ You are now on { swap-vendor } branch ************";
fi