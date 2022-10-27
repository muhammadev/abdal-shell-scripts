#!/bin/sh

# TODO: ADD FLAGS AND ERROR HANDLING

# cd to abdal directory
cd C:/laragon/www/abdal

# restore mix config file back to original
git restore "C:\laragon\www\abdal\webpack.mix.js"

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

# pull changes from dev/phase-two branch
git checkout dev/phase-two && git pull origin dev/phase-two

# pull changes from dev/front-end & merge changes from dev/phase-two branch to dev/front-end branch
git checkout dev/front-end && git pull origin dev/front-end && git merge dev/phase-two

# push changes to dev/front-end branch
git push origin dev/front-end

echo "📦 Changes have been pushed to dev/front-end branch successfully."
