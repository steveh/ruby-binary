#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Usage: $0 <ruby_version>"
  exit 1
fi

RUBY_VERSION=$1
ARCH=$(uname -m)
WORKDIR=$(pwd)

# Download Ruby if it doesn't already exist
if [ ! -f ruby-$RUBY_VERSION.tar.gz ]; then
  RUBY_MAJOR_VERSION=$(echo $RUBY_VERSION | cut -d. -f1)
  RUBY_MINOR_VERSION=$(echo $RUBY_VERSION | cut -d. -f2)

  curl -sSL -o ruby-$RUBY_VERSION.tar.gz https://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR_VERSION.$RUBY_MINOR_VERSION/ruby-$RUBY_VERSION.tar.gz
fi

tar -zxvf ruby-$RUBY_VERSION.tar.gz
cd ruby-$RUBY_VERSION
mkdir build
cd build
../configure
make

TMPDIR=$(mktemp -d)
make install DESTDIR=$TMPDIR
cd $TMPDIR
tar -zcvf $WORKDIR/ruby-$RUBY_VERSION-linux-$ARCH.tar.gz *
rm -rf $TMPDIR

cd $WORKDIR
