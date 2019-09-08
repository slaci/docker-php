#!/usr/bin/env bash

set -xe

package="slaci/php-fpm"
versions=(7.1 7.2 7.3)
latestTagName=${versions[-1]}

git fetch
for v in "${versions[@]}"; do
  git checkout "$v"
  git pull
  tag="${package}:$v";
  isLatest=false
  tagsArg="-t $tag"

  if [ "$v" = "$latestTagName" ]; then
    isLatest=true
    tagsArg="$tagsArg -t ${package}:latest"
  fi

  docker build $tagsArg --no-cache --pull .
  docker push "$tag"
  if $isLatest; then
    docker push "${package}:latest"
  fi

  xdebugTag="${tag}-xdebug"
  docker build -t "$xdebugTag" --no-cache --pull --build-arg xdebug="1" .
  docker push "$xdebugTag"
done
