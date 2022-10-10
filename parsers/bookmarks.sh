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
  link_name=$([ "$description" == "" ] && echo "$name" || echo "$name - $description")

  echo -e "    <DT><H3>$section</H3></DT>
    <DL>
      <DT><A HREF=\"$url\">$link_name</A></DT>
    </DL>"
}