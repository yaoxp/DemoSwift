#!/bin/sh

git filter-branch --env-filter '

an="$GIT_AUTHOR_NAME"
am="$GIT_AUTHOR_EMAIL"
cn="$GIT_COMMITTER_NAME"
cm="$GIT_COMMITTER_EMAIL"

if [ "$GIT_COMMITTER_EMAIL" = "16010556@cnsuning.com" ]
then
    cn="yaoxp"
    cm="viq_xp@126.com"
fi
if [ "$GIT_AUTHOR_EMAIL" = "16010556@cnsuning.com" ]
then
    an="yaoxp"
    am="viq_xp@126.com"
fi

export GIT_AUTHOR_NAME="$an"
export GIT_AUTHOR_EMAIL="$am"
export GIT_COMMITTER_NAME="$cn"
export GIT_COMMITTER_EMAIL="$cm"
'
