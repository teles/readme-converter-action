#!/bin/bash

function echo_csv_begin {
	echo -e "section,name,description,url"
}

function echo_csv_item {
  section="$1"
  url="$2"
  name="$3"
  description="$4"
  description=$([ "$description" == "" ] && echo "null" || echo "$description")

  echo -e "\"$section\",\"$name\",\"$description\",\"$url\""
}