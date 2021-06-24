#!/bin/bash

BUILD=`pwd`/build
REPO="git@github.com:${CIRCLE_PROJECT_USERNAME}/xmlcatalogs.org.git"

echo "Publishing to gh-pages in $REPO"

mkdir $HOME/staging
cd $HOME/staging

git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USER

git clone --quiet --branch=gh-pages "$REPO" gh-pages
cd gh-pages

# Set this in the CircleCI "Settings/Environment Variables" section
if [ "$GITHUB_CNAME" != "" ]; then
    echo $GITHUB_CNAME > CNAME
fi;

rsync -ar --delete --exclude README --exclude .git --exclude .circleci $BUILD/website/ ./

git add --all .
git commit -m "CircleCI build: $CIRCLE_BUILD_URL"
git push -fq origin gh-pages
