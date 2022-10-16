#!/bin/sh

# first, cd to abdal directory
cd C:/laragon/www/abdal;

# second, check which branch you are on
brach=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
echo "************ You are on branch $brach ************"

# todo >> exit if you are not on vendor related branch

# second, restore mix config file back to original
git restore "C:\laragon\www\abdal\webpack.mix.js"
echo "************ Restore mix config file back to original ************"


# third, git add changes & commit
git add .
echo ">>> Enter a commit message for your changes."
read commitMessage
git commit -m "$commitMessage"
echo "************ Commit message\n { $commitMessage } ************"


# fifth, pull changes from dev/vendor branch
git checkout dev/vendor && git pull origin dev/vendor;

# sixth, pull changes from dev/vendor-front & merge changes from dev/vendor branch to dev/vendor-front branch
git checkout dev/vendor-front && git pull origin dev/vendor-front && git merge dev/vendor;
echo "************ Merge changes from dev/vendor branch to dev/vendor-front branch ************"

# seventh, if previous branch is not dev/vendor-front, then merge changes from previous branch to dev/vendor-front branch
if [ "$branch" = "dev/vendor-front" ]; then
    git checkout swap-vendor && git merge "$branch";
    echo "************ Merge changes from $branch branch to swap-vendor branch ************"
fi

# eighth, push changes to origin dev/vendor-front branch
git push origin swap-vendor;
echo "📦 Changes have been pushed to dev/vendor-front branch successfully.";