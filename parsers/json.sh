#!/bin/bash

function echo_json_begin {
	title="$1"
	echo -e "{\"title\": \"$title\", \"links\":["
}

function echo_json_end {
	echo -e "]}"
}

function echo_json_item {
  section="$1"
  url="$2"
  name="$3"
  description="$4"
  description=$([ "$description" == "" ] && echo "null" || echo "$description")

  echo -e "{\"section\": \"$section\", \"name\": \"$name\", \"description\": \"$description\", \"url\": \"$url\"},"
}

function after_json_parser {
  output="$1"
  echo "$1" | sed 'x;${s/,$//;p;x;};1d'
}