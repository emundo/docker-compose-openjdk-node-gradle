#!/usr/bin/env bash

echo 'Lade alle verfügbaren Gradle-Versionen'
PAGE_URL='https://services.gradle.org/versions/all'
PAGE_DATA="$(curl -fsSL "$PAGE_URL")"
# Parse alle Release-Versionen aus JSON-String
allGradleVersions=()
allGradleVersions=( $(
		echo "$PAGE_DATA" \
			| grep -oP '(?<="version" : ")[\d.]+(?=",)'
))

# Suche die höchste Minor-Version die passt
FULL_GRADLE_VERSION="$(
		echo "${allGradleVersions[@]}" | xargs -n1 \
			| grep -E "^${GRADLE_VERSION}(.*)$" \
            | sort -V \
			| tail -1
	    )" || true
echo "Benutze Gradle ${FULL_GRADLE_VERSION}"

wget https://services.gradle.org/distributions/gradle-"${FULL_GRADLE_VERSION}"-bin.zip \
    --output-document=gradle.zip && \
    unzip gradle.zip && \
    rm gradle.zip && \
    mv "gradle-${FULL_GRADLE_VERSION}" "${GRADLE_HOME}/" && \
    ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle