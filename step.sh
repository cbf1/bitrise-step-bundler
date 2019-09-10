#!/bin/bash -ex

GEMFILE_LOCK="Gemfile.lock"

if [ -f "${GEMFILE_LOCK}" ]; then

  extract_version() { tr -cd "[:digit:]\."; }

  BUNDLER_VERSION=$(bundler --version | extract_version)
  BUNDLED_WITH=$(tail -n 1 "${GEMFILE_LOCK}" | extract_version)

  unset -f extract_version

  if [ "${BUNDLED_WITH}" != "${BUNDLER_VERSION}" ]; then
    gem install bundler -v "${BUNDLED_WITH}" --no-document --force
  fi

  bundle check || bundle install --jobs "${bundle_install_jobs}" --retry "${bundle_install_retry}"

fi
