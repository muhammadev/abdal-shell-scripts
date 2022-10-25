#!/bin/bash

# COPY FROM https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
# More safety, by turning some bugs into errors.
# Without `errexit` you don’t need ! and can replace
# ${PIPESTATUS[0]} with a simple $?, but I prefer safety.
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test >/dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

# option --output/-o requires 1 argument
LONGOPTS=pull
OPTIONS=p

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

p=n
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
    -p | --pull)
        p=y
        shift
        ;;
    --)
        shift
        break
        ;;
    *)
        echo "Programming error"
        exit 3
        ;;
    esac
done

# COMMENTED OUT BECAUSE IT MEANS OPTIONS ARE REQUIRED WHICH IS NOT AT THE TIME
# handle non-option arguments
# if [[ $# -ne 1 ]]; then
#     echo "$0: A single input file is required."
#     exit 4
# fi

# END COPY FROM https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

# store the script directory path before cd
basePath=$(dirname -- "$(readlink -f -- "$0")")

# cd to abdal directory and set the cleanup function
cd C:/laragon/www/abdal

# trap ctr+c
trap ctrl_c EXIT
function ctrl_c() {
    git restore "C:\laragon\www\abdal\webpack.mix.js"
    echo -e "\n >>> switch webpack.mix.js file to original \n"
}

if [[ $p = y ]]; then
    # checkout the latest version of dev/vendor
    {
        git checkout dev/vendor && git pull origin dev/vendor && echo -e "\n >>> Pulled changes from dev/vendor branch \n"
    } || {
        echo -e "\n >>> something went wrong!"
        read -p "Press enter to continue..."
    }
    # checkout the latest version of dev/vendor-front and merge it with the latest version of dev/vendor
    {
        git checkout dev/vendor-front && git pull origin dev/vendor-front && git merge dev/vendor && echo -e "\n >>> Pull changes from dev/vendor-front and merge changes from dev/vendor branch to dev/vendor-front branch \n"
    } || {
        echo -e "\n >>> something went wrong!"
        read -p "Press enter to continue..."
    }
else
    echo -e "\n >>> not pulling... \n"
fi

# switch webpack.mix.js file to mixConfigVendor file which will comment out "website" and "business" sections
cp "$basePath\mixConfigVendor.txt" "C:\laragon\www\abdal\webpack.mix.js"
echo -e "\n >>> switch webpack.mix.js file to mixConfigVendor file which will comment out 'website' and 'business' sections \n"

# opening vs code
echo -e "\n >>> opening code... \n"
code .

# run npm watch command to start the development server
npm run watch
