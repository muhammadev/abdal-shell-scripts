#!/bin/sh

# first, cd to abdal directory and set the cleanup function
cd C:/laragon/www/abdal;

# trap ctr+c
function ctrl_c() {
    git restore "C:\laragon\www\abdal\webpack.mix.js";
    echo "************ switch webpack.mix.js file to original ************"
}
trap ctrl_c INT;

# second, checkout the latest version of dev/phase-two
git checkout dev/phase-two && git pull origin dev/phase-two;
echo "************ Pull changes from dev/phase-two branch ************"

# third, checkout the latest version of dev/front-end and merge it with the latest version of dev/phase-two
git checkout dev/front-end && git pull origin dev/front-end && git merge dev/phase-two;
echo "************ Pull changes from dev/front-end branch and merge dev/phase-two ************"

# fourth, switch webpack.mix.js file to mixConfigBusiness file which will comment out "website" and "vendor" sections
cp "C:\shell scripts\mixConfigBusiness.txt" "C:\laragon\www\abdal\webpack.mix.js";
echo "************ switch webpack.mix.js file to mixConfigBusiness file which will comment out 'website' and 'vendor' sections ************"

# fifth, run npm watch command to start the development server
npm run watch;
# echo "📦 npm run watch command has been executed successfully.";
