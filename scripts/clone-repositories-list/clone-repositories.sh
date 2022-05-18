#/bin/bash

#Checking if necessary environment variables are set
if [[ -z "${ORG_NAME}" ]] ; then
  echo "ORG_NAME environment variable is not set"
  exit
fi

if [[ -z "${VCS_URL}" ]] ; then
  echo "VCS_URL environment variable is not set"
  exit
fi

#List of private repositories and tags from arguments
declare -a repos=("$@")

# Disabe GIT advice
git config --global advice.detachedHead false

for PACKAGE in "${repos[@]}"; do
    repoName="$(cut -d'@' -f1 <<< $PACKAGE)"
    repoVersion="$(cut -d'@' -f2 <<< $PACKAGE)"
    if [ -d "./local-repositories/$repoName" ] 
        then
            echo "Repository $repoName already exists locally." 
        else
            echo "Cloning git@$VCS_URL:$ORG_NAME/$repoName.git..."
            git clone -b $repoVersion git@$VCS_URL:$ORG_NAME/$repoName.git ./local-repositories/$repoName
    fi
done   

 