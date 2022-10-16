#!/bin/sh

# first, cd to abdal directory and set the cleanup function
cd C:/laragon/www/abdal;

# trap ctr+c
function ctrl_c() {
    git restore "C:\laragon\www\abdal\webpack.mix.js";
    echo "************ switch webpack.mix.js file to original ************"
}
trap ctrl_c INT;

if [ $1 ] && [ `git branch --list "$1"` ];
then
  # second, checkout the latest version of dev/phase-two
  git checkout dev/phase-two && git pull origin dev/phase-two;
  echo "************ Pull changes from dev/phase-two branch ************"

  # third, checkout the latest version of dev/front-end and merge it with the latest version of dev/phase-two
  # and then merge new changes to $1 branch
  git checkout dev/front-end && git pull origin dev/front-end && git merge dev/phase-two;
  git checkout $1 && git merge dev/front-end;
  echo "************ Pull changes from dev/front-end branch and merge dev/phase-two, then merge new changes to $1 ************"

  # fourth, switch webpack.mix.js file to mixConfigBusiness file which will comment out "website" and "vendor" sections
  cp "C:\shell scripts\mixConfigBusiness.txt" "C:\laragon\www\abdal\webpack.mix.js";
  echo "************ switch webpack.mix.js file to mixConfigBusiness file which will comment out 'website' and 'vendor' sections ************"

  # fifth, run npm watch command to start the development server
  npm run watch;
  echo "📦 npm run watch command has been executed successfully.";
else
  echo -e "\n>>> branch not provided or not found"
fi
