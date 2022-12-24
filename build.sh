#!/usr/bin/env bash

BUILD_VERSION=$1
FULL_REBUILD=$2

set -xe

package="slaci/php-fpm"
declare -A latestBugfixVer=([7.0]=33 ["7.1"]=33 ["7.2"]=34 ["7.3"]=33 ["7.4"]=33 ["8.0"]=26 ["8.1"]=13 ["8.2"]=0)
latestVersion="8.2"

if [ -z "${BUILD_VERSION}" ]; then
  versions=("8.0" "8.1", "8.2")
else
  versions=("${BUILD_VERSION}")
fi

for minorVersion in "${versions[@]}"; do
  lastBugfixVer="${latestBugfixVer[$minorVersion]}"

  if [ -z "${FULL_REBUILD}" ]; then
    versionsToBuild=("${lastBugfixVer}")
  else
    versionsToBuild=($(seq 0 1 "${lastBugfixVer}"))
  fi

  for bugfixVersion in "${versionsToBuild[@]}"; do
    fullversion="${minorVersion}.${bugfixVersion}"

    bugfixTag="${package}:${fullversion}"
    xdebugBugfixTag="${bugfixTag}-xdebug"
    tagsArg="-t ${bugfixTag}"
    xdebugTagsArg="-t ${xdebugBugfixTag}"
    tagsToPush="${bugfixTag} ${xdebugBugfixTag}"

    isLatestMinor=false
    if [ "${bugfixVersion}" -eq "${lastBugfixVer}" ]; then
      minorTag="${package}:${minorVersion}"
      xdebugMinorTag="${minorTag}-xdebug"
      tagsArg="${tagsArg} -t ${minorTag}"
      xdebugTagsArg="${xdebugTagsArg} -t ${xdebugMinorTag}"
      tagsToPush="${tagsToPush} ${minorTag} ${xdebugMinorTag}"
      isLatestMinor=true
    fi

    if [ "${minorVersion}" = "${latestVersion}" ] && ${isLatestMinor}; then
      latestTag="${package}:latest"
      tagsArg="$tagsArg -t ${latestTag}"
      tagsToPush="${tagsToPush} ${latestTag}"
    fi

      #--platform linux/amd64,linux/arm64,linux/arm/v7 \
    docker buildx build \
      --platform linux/amd64 \
      --load \
      --build-arg FROM_VERSION="${fullversion}" \
      --pull \
      ${tagsArg} \
      "${minorVersion}"

    docker buildx build \
      --platform linux/amd64 \
      --load \
      --build-arg FROM_VERSION="${fullversion}" \
      --build-arg xdebug="1" \
      --cache-from "${bugfixTag}" \
      ${xdebugTagsArg} \
      "${minorVersion}"

    tagsAry=(${tagsToPush})
    for tag in "${tagsAry[@]}"; do
      docker push ${tag}
    done
  done
done
