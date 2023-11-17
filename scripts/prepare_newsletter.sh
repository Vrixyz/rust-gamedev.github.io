#!/bin/bash

# This scripts parses existing news, and copies the newsletter template
# alongside the others, with its incremented id number.
# This script also replaces the TODOs related to the news id number.

set -v

read -r -d '\n' -a news <<< `find content/news/ -type d -printf "%f\n"| sort -n`
echo $news
echo ${news[-1]}

export last_news=`echo ${news[-1]} | sed -r s/0//`
export news_to_create_simple=`echo $((last_news+1))`
echo $news_to_create_simple
printf "%#03s" $news_to_create_simple
export news_to_create=`printf "%#03s" $news_to_create_simple`
echo $news_to_create
read -e -p "Do you want to create issue $news_to_create? (y/n): " choice

[[ "$choice" != [Yy]* ]] && exit

echo "accepted"

export new_file=`echo "content/news/$news_to_create/index.md"`

echo $new_file

mkdir -p content/news/$news_to_create && cp newsletter-template.md $new_file

sed -i 's/{TODO_id}/'$news_to_create_simple'/g' $new_file