#!/bin/sh

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
LONGOPTS=pull,commit
OPTIONS=pc

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

p=n c=n
# now enjoy the options in order and nicely split until we see --
while true; do
  case "$1" in
  -p | --pull)
    p=y
    shift
    ;;
  -c | --commit)
    c=y
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

# COMMENTED OUT BECAUSE IT MEANS OPTIONS ARE REQUIRED WHICH ARE NOT AT THE TIME
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
function ctrl_c() {
  git restore "C:\laragon\www\abdal\webpack.mix.js"
  echo -e "\n >>> switch webpack.mix.js file to original \n"
}
trap ctrl_c INT

if [ $1 ] && [[ $(git branch --list "$1") ]]; then

  # switch webpack.mix.js file to original
  git restore "C:\laragon\www\abdal\webpack.mix.js"
  echo -e "\n >>> switch webpack.mix.js file to original \n"

  if [[ $c = y ]]; then
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
  else
    echo -e "\n >>> proceeding without add & commit... \n"
  fi

  if [[ $p = y ]]; then
    # checkout the latest version of dev/vendor
    git checkout dev/vendor && git pull origin dev/vendor
    echo -e "\n >>> Pull changes from dev/vendor branch \n"

    # checkout the latest version of dev/vendor-front and merge it with the latest version of dev/vendor
    # and then merge new changes to $1 branch
    git checkout dev/vendor-front && git pull origin dev/vendor-front && git merge dev/vendor
    git checkout $1 && git merge dev/vendor-front
    echo -e "\n >>> Pull changes from dev/vendor-front branch and merge dev/vendor, then merge new changes to $1 \n"
  else
    echo -e "\n >>> proceeding without pulling from higher branches... \n"
  fi

  # push changes to $1 branch
  {
    git push origin $1 && echo -e "\n 📦 Changes have been pushed to $1 branch successfully. \n"
  } || {
    echo -e "\n >>> something went wrong! Please check if push command failed. \n"
  }
else
  echo -e "\n >>> branch not provided or not found \n"
fi
