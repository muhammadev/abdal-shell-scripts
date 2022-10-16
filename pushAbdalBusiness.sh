#!/bin/sh

# first, cd to abdal directory
cd C:/laragon/www/abdal;

# second, restore mix config file back to original
git restore "C:\laragon\www\abdal\webpack.mix.js"

# third, git add changes
git add .

# fourth, git commit changes
echo ">>> Enter a commit message for your changes."
read commitMessage
git commit -m "$commitMessage"

# fifth, pull changes from dev/phase-two branch
git checkout dev/phase-two && git pull origin dev/phase-two;

# sixth, pull changes from dev/front-end & merge changes from dev/phase-two branch to dev/front-end branch
git checkout dev/front-end && git pull origin dev/front-end && git merge dev/phase-two;

# seventh, push changes to dev/front-end branch
git push origin dev/front-end;

echo "📦 Changes have been pushed to dev/front-end branch successfully.";