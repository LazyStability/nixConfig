# Original File: https://github.com/LukeSmithxyz/voidrice/blob/ed9633da3f876b6c9dae13434fb7ea30208a5b5f/.local/bin/rssget
# This file is licensed under GPL-3.0 by Luke Smith
/*
    Copyright (C) 2018 Luke Smith

    This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/
{
  writeShellApplication,
  config,
  pkgs,
  ...
}:
let
  rssadd = pkgs.callPackage ./rssadd.nix { };
  applauncher =
    if config.programs.fuzzel.enable then
      "fuzzel"
    else if config.programs.wofi.enable then
      "wofi"
    else
      builtins.throw "No supported applauncher actived. Use programs.wofi.enable or programs.fuzzel.enable.";

in
writeShellApplication {
  name = "rssget";
  runtimeInputs = [
    pkgs.wl-clipboard
    pkgs.curl
    rssadd
  ];
  text = ''
    # Searches the website for RSS feeds and adds them to newsboat url list. Can
    # also find hidden RSS feeds on various websites, namely Youtube, Reddit,
    # Vimeo, Github, Gitlab and Medium. Gets site url as $1 or (if not present)
    # from X clipboard. Gets tags as $2. If it finds more than one feed, calls
    # dmenu for the user to choose which one to add. I have bound it to a keyboard
    # shortcut so i copy a site link and easily add its feed to the reader.

    # Inspired by and based on the logic of this extension:
    # https://github.com/shevabam/get-rss-feed-url-extension

    # This script requires rssadd to add feeds to the list.

    getlink () {
    	local url="$1/"
    	feeds="$(curl -s "$url" | grep -Ex '.*type=.*(rss|rdf|atom).*' | sed 's/ //g')"
        # shellcheck disable=SC2001
    	url="$(echo "$url" | sed 's|^\(https://[^/]*/\).*|\1|')"

    	for rsspath in $feeds; do
                # shellcheck disable=SC2001
    		rsspath="$(echo "$rsspath" | sed -n "s|.*href=['\"]\([^'\"]*\)['\"].*|\1|p")"
    	if echo "$rsspath" | grep "http" > /dev/null; then
    		link="$rsspath"
    	elif echo "$rsspath" | grep -E "^/" > /dev/null; then
                # shellcheck disable=SC2001
    		link="$url$(echo "$rsspath" | sed 's|^/||')"
    	else
    		link="$url$rsspath"
    	fi
    	echo "$link"
    	done
    }

    getRedditRss() {
    	echo "''${1%/}.rss"
    }

    getYoutubeRss() {
    	local url=$1

    	feed_url=$(curl --silent "$url" | grep -oh 'https://www.youtube.com/feeds/videos.xml[^\"]*' | sort -u)

    	echo "$feed_url"
    }

    getVimeoRss() {
        local url="$1"
            if echo "$url" | grep -q "/videos$"; then
                feed_url=$(echo "$url" | sed 's/\/videos$//' | sed 's/\/$/\/rss/')
            else
                feed_url="''${url}/videos/rss"
            fi
        echo "$feed_url"
    }

    getGithubRss () {
    	local url="''${1%/}"
    	if echo "$url" | grep -E "github.com/[^/]*/[a-zA-Z0-9].*" >/dev/null ; then
    		url=''${url%/tree/*}
    		url=''${url%/blob/*}

    		echo "''${url}/commits.atom"
    		echo "''${url}/releases.atom"
    		echo "''${url}/tags.atom"
    	elif echo "$url" | grep -E "github.com/[^/]*(/)" >/dev/null ; then
    		echo "''${url}.atom"
    	fi
    }

    getGitlabRss () {
        local url="''${1%/}"

        url=''${url%/-/tree/*}
        url=''${url%/-/blob/*}

        echo "''${url}.atom"
    }

    getMediumRss () {
        # shellcheck disable=SC2001
        echo "$1" | sed 's|/tag/|/feed/|'
    }


    if [ -z "''${1-}" ]; then
        url="$(wl-paste)"
        [ -z "$url" ] && echo "usage: $0 url 'tag1 tag2 tag3'" && exit 1
    else
    	url="$1"
    fi

    declare -a list=()

    # original regex from luke smith, didnt work for me
    # old_yt_regex="^(http(s)?://)?((w){3}\.)?(youtube\.com|invidio\.us|invidious\.flokinet\.to|invidious\.materialio\.us|iv\.datura\.network|invidious\.perennialte\.ch|invidious\.fdn\.fr|invidious\.private\.coffee|invidious\.protokolla\.fi|invidious\.privacyredirect\.com|yt\.artemislena\.eu|yt\.drgnz\.club|invidious\.incogniweb\.net|yewtu\.be|inv\.tux\.pizza|invidious\.reallyaweso\.me|iv\.melmac\.space|inv\.us\.projectsegfau\.lt|inv\.nadeko\.net|invidious\.darkness\.services|invidious\.jing\.rocks|invidious\.privacydev\.net|inv\.in\.projectsegfau\.lt|invidious\.drgns\.space)/(channel|user|c).+"

    yt_regex="^(http(s)?://)?((w){3}\.)youtube\.com/@[a-zA-Z0-9]+/?"
    reddit_regex="^(http(s)?://)?((w){3}\.)?reddit\.com.*"
    vimeo_regex="^(http(s)?://)?((w){3}.)?vimeo\.com.*"
    if echo "$url" | grep -Ex "$yt_regex" >/dev/null ; then
    	list=( "$(getYoutubeRss "$url")" )
    elif echo "$url" | grep -Ex "$reddit_regex" >/dev/null ; then
    	list=( "$(getRedditRss "$url")" )
    # vimeo actually works with getlink
    elif echo "$url" | grep -E "$vimeo_regex" >/dev/null ; then
    	list=( "$(getVimeoRss "$url")" )
    elif echo "$url" | grep -E "github.com" >/dev/null ; then
    	list=( "$(getGithubRss "$url")" )
    # gitlab also works with getlink
    elif echo "$url" | grep -E "gitlab.com/[a-zA-Z0-9].*" >/dev/null ; then
    	list=( "$(getGitlabRss "$url")" )
    elif echo "$url" | grep -E "medium.com/tag" >/dev/null ; then
    	list=( "$(getMediumRss "$url")" )
    else
    	list=( "$(getlink "$url")" )
    fi

    [ "$(echo "''${list[*]}" | wc -l)" -eq 1 ] && chosen_link="''${list[*]}" || chosen_link=$(printf '%s\n' "''${list[@]}" | ${applauncher} -d -p "Choose a feed:")
    tags="''${2-}"
    echo "$chosen_link" "$tags"
    rssadd "$chosen_link" "$tags"
  '';
}
