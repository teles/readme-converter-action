#!/bin/bash
source parsers/bookmarks.sh 
source parsers/json.sh
source parsers/csv.sh

function on_title_match {
  type="$1"
  title="$2"

  case $type in
    "bookmarks")
      echo_bookmarks_begin "$title";; 
    "csv")
      echo_csv_begin;;
    "json")
      echo_json_begin "$title";;
  esac
}

function on_link_match {
  type="$1"
  section="$2"
  url="$3"
  name="$4"
  description="$5"
  title="$6"

  case $type in
    "bookmarks")
      echo_bookmarks_item "$section" "$url" "$name" "$description" "$title";;
    "csv")
      echo_csv_item "$section" "$url" "$name" "$description";;
    "json")
      echo_json_item "$section" "$url" "$name" "$description" "$title";;
  esac
}

function after_last_line {
  type="$1"

  case $type in
    "bookmarks")
      echo_bookmarks_end;;
    "csv")
      echo "";;
    "json")
      echo_json_end;;
  esac
}

function post_parser {
  output="$1"  

  case $type in
    "bookmarks")
      echo "$output";;  
    "csv")
      echo "$output";;        
    "json")
      after_json_parser "$output";;
  esac  
}

function parse {
  type="$1"
  pattern_title="^# (.*)"
  pattern_section="^## (.*)"
  pattern_name="\ \[(.*)\]"
  pattern_url="\(([^()]*)\)"
  pattern_description="( [-:] )*(.*$)"
  pattern_link="^\*$pattern_name$pattern_url$pattern_description"
  section_counter=0
  link_counter=0
  line_counter=0

  while IFS= read -r line; do  	

    if [[ "$line" =~ $pattern_section ]]; then
       counter=0
       for group in "${BASH_REMATCH[@]}"; do
           case $counter in
             "1")
              section_counter=$(( $section_counter + 1))
              section="$group";; 
          esac        
          counter=$(( $counter + 1))
       done

    elif [[ "$line" =~ $pattern_title ]]; then
       counter=0
       for group in "${BASH_REMATCH[@]}"; do
           case $counter in
             "1")
              title="$group"
              if [[ "$line_counter" -eq 0 ]]; then
                on_title_match "$type" "$title"
              fi
              ;; 
          esac
          counter=$(( $counter + 1))
      done

    elif [[ "$line" =~ $pattern_link ]]; then
       counter=0
       is_last_match=0
       for group in "${BASH_REMATCH[@]}"; do
           case $counter in
             "1")
              link_counter=$(( $link_counter + 1))
              is_last_match=0
              name="$group";;
            "2")
              url="$group";;
            "4")
              description="$group"
              is_last_match=1
              ;;
          esac          
          if [[ "$is_last_match" -eq 1 ]]; then
            on_link_match "$type" "$section" "$url" "$name" "$description" "$title"
          fi          
          counter=$(( $counter + 1))
       done       
    fi
    line_counter=$(( $line_counter + 1))
  done 
  after_last_line "$type"
}

# main
type="bookmarks"

while getopts "t:" OPT; do
  case "$OPT" in
    t) type="${OPTARG}";;    
    *) exit 0;;
  esac
done

output=$(parse "$type")
post_parser "$output"
