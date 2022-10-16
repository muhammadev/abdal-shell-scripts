#!/bin/bash
# first, cd to abdal directory and set the cleanup function
cd C:/laragon/www/abdal;

# trap ctr+c
trap ctrl_c EXIT;
function ctrl_c() {
    git restore "C:\laragon\www\abdal\webpack.mix.js";
    echo "************ switch webpack.mix.js file to original ************"
}

# second, checkout the latest version of dev/vendor
git checkout dev/vendor && git pull origin dev/vendor;
echo "************ Pull changes from dev/vendor branch ************"


# third, checkout the latest version of dev/vendor-front and merge it with the latest version of dev/vendor
git checkout dev/vendor-front && git pull origin dev/vendor-front && git merge dev/vendor;
echo "************ Pull changes from dev/vendor-front and merge changes from dev/vendor branch to dev/vendor-front branch ************"

# fourth, switch webpack.mix.js file to mixConfigVendor file which will comment out "website" and "business" sections
cp "C:\shell scripts\mixConfigVendor.txt" "C:\laragon\www\abdal\webpack.mix.js";
echo "************ switch webpack.mix.js file to mixConfigVendor file which will comment out 'website' and 'business' sections ************"

# fifth, run npm watch command to start the development server
npm run watch;
echo "📦 npm run watch command has been executed successfully.";