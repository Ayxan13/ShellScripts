#!/bin/zsh
set -e # exit on error

# Created by: Ayxan Haqverdili 10 Feb 2022

# Merges one branch with another one. 
# Push the result to the remote repository.

# Usage: zsh git_merge.sh <branch_from> <branch_to>
# param: branch_from: The branch to merge from.
# param: branch_to: The branch to merge to.

# If the branch_from is not specified, the default is the current branch.
# If the branch_to is not specified, the default is 'dev'.


# Called on fail to print error message and exit.
# Usage: fail <message> <error code>
# param: message: the error message to print
# param: error code: the error code to exit with
function fail {
    error="$1"
    if [ -z "$1" ]; then
        error="Unknown error"
    fi

    autoload -U colors
    colors
    echo "${fg[red]}Error: $error${reset_color}"

    exit $2
}


branchFrom="$1"
branchTo="$2"

if [ -z $branchTo ]; then
    branchTo="dev"
fi

if [[ -z $branchFrom ]]; then
    branchFrom=$(git rev-parse --abbrev-ref HEAD)
fi

echo ">> Attempting to merge '$branchFrom' into '$branchTo' <<"

echo "Cecking out '$branchFrom'"
git checkout $branchFrom || (fail "Failed to checkout '$branchFrom'" 1)

echo "Pushing '$branchFrom' to origin"
git push origin $branchFrom || git push --set-upstream origin $branchFrom || (fail "Failed to push '$branchFrom' to origin" 2)

echo "Checking out '$branchTo'"
git checkout $branchTo || (fail "Failed to checkout '$branchTo'" 3)

echo "Merging '$branchFrom' into '$branchTo'"
git merge $branchFrom  || (fail "Failed to merge '$branchFrom' into '$branchTo'" 4)
git push origin $branchTo || (fail "Failed to push '$branchTo' to origin" 5)

# echo "Cecking out '$branchFrom'"
# git checkout $branchFrom || (fail "Failed to checkout '$branchFrom'" 1)

echo "Deleting '$branchFrom' from local"
git branch -d $branchFrom || (fail "Failed to delete '$branchFrom' from local" 6)

# echo "Pushing '$branchFrom' to origin"
# git push origin $branchFrom || (fail "Failed to push '$branchFrom' to origin" 2)
