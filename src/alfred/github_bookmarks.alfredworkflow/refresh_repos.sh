#!/bin/bash
PATH="$PATH:/usr/local/bin"

if [[ -z $GITHUB_TOKEN ]]; then
  echo "Error: GITHUB_TOKEN is not set"
  exit 1
fi

if ! jq --version > /dev/null; then
  echo "Error: jq must be installed (brew install jq)"
  exit 1
fi

repos="[]"
let page_num=0

while true
do
  let page_num++
  page=$(
    curl -s -L -H "User-Agent: temochka" -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/user/repos?page=${page_num}" |
      jq -j 'map({
        title: .name,
        match: [[(.name | split("[-_]";"g") | join(""))], [.name], (.name | split("[-_]";"g"))] | add | unique | join(" "),
        subtitle: (.description // "No description"),
        arg: .html_url,
        quicklookurl: .html_url
      })'
  )
  repos=$(jq -j add <<< "[${repos},${page}]")
  if [[ "$page" == "[]" ]]; then
    break
  else
    sleep 1
  fi
done

total_count=$(jq -j length <<< "$repos")

mkdir -p ~/.alfred
jq "{items:sort_by(.name)}" <<< "$repos" > ~/.alfred/gh-bookmarks.json
echo "Success: $total_count $([[ $total_count == "1" ]] && echo 'bookmark' || echo 'bookmarks') saved"
