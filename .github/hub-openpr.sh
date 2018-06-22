#!/bin/bash
# Author: Noel Colon <ncolon20@gmail.com>

# for external tickets
echo ticket# 
read TICKET_URL
ticket_url="[TICKET]($TICKET_URL)"

echo screenshots? 
read SCREENSHOTS

if [[ $SCREENSHOTS == 'y'  ]]; then
	screenshots_template=$(cat ~/.dotfiles/.github/templates/screenshots.md)
fi

echo checklist?
read CHECKLIST

if [[ $CHECKLIST == 'y'  ]]; then
	checklist_template=$(cat ~/.dotfiles/.github/templates/checklist.md)
fi

B=$(git show -s --format=%B)
SUBJECT=$(echo -e "$B" | head -n 1)
COMMITS=$(echo -e "$B" | tail -n +2)
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

git push -u origin $BRANCH_NAME

BASE=
USERS=
LABELS=

hub pull-request -b $BASE -r $USERS -l $LABELS -F- <<<"$SUBJECT


$ticket_url

$COMMITS

$screenshots_template

$checklist_template"

