#!/usr/bin/env bash

set -xe

package="slaci/php-fpm"
versions=(7.2 7.3 7.4)
latestTagName=${versions[-1]}

for v in "${versions[@]}"; do
  tag="${package}:$v";
  isLatest=false
  tagsArg="-t $tag"

  if [ "$v" = "$latestTagName" ]; then
    isLatest=true
    tagsArg="$tagsArg -t ${package}:latest"
  fi

  docker build $tagsArg --no-cache --pull "$v"
  docker push "$tag"
  if $isLatest; then
    docker push "${package}:latest"
  fi

  xdebugTag="${tag}-xdebug"
  docker build -t "$xdebugTag" --no-cache --pull --build-arg xdebug="1" "$v"
  docker push "$xdebugTag"
done
