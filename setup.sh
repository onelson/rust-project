#!/usr/bin/env bash

set -e

HIGHLIGHT='\033[0;33m'
NC='\033[0m' # No Color

### Initializes the project from scratch

echo -e "\nPreparing to build your ${HIGHLIGHT}personal dev images${NC}.\n"
echo -e "${HIGHLIGHT}If this your first time running this, it can take a while...${NC}\n"

# The containers are built one at a time since they share a CARGO_HOME and we don't
# want to have file contention. The files pulled down by cargo should be applicable
# the other, so the 2nd will essentially reuse the cache created by the first.

# The uid/gid values will be read by the docker file as build args and used to create a
# user/group matching the current user *inside* the container.
docker-compose build \
  --build-arg "DEVELOPER_UID=$(id -u)" \
  --build-arg "DEVELOPER_GID=$(id -g)" \
  dev

echo -e "\nBuild complete and ready to run."
