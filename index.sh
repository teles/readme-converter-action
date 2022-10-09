#!/bin/bash

function echo_bookmarks_begin {
	title="$1"
	echo -e "<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">
<DL>
  <DT><H3>$title</H3></DT>
<DL>"
}

function echo_bookmarks_end {
	echo -e "  </DL>    
</DL>"
}

function echo_bookmarks_item {
  section="$1"
  url="$2"
  name="$3"
  description="$4"

  echo -e "    <DT><H3>$section</H3></DT>
    <DL>
      <DT><A HREF=\"$url\">$name - $description</A></DT>
    </DL>"
}


function parse {
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
                echo_bookmarks_begin "$title"
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
            echo_bookmarks_item "$section" "$url" "$name" "$description"
          fi          
          counter=$(( $counter + 1))
       done       
    fi
    line_counter=$(( $line_counter + 1))
  done 
  echo_bookmarks_end
}

function main { 
  parse 
}

main