FROM theomn/rustup-base:latest

RUN apt-get update \
    && apt-get install --no-install-recommends -y sudo \
    && rm -rf /var/lib/apt/lists/*

# Once all the package/lib installs are complete, configure the local user
# and switch to userland.
ARG DEVELOPER_UID
ARG DEVELOPER_GID

# Make a user and group to match the user running the build
RUN groupadd -g ${DEVELOPER_GID} developer \
    && useradd -u ${DEVELOPER_UID} \
               -g ${DEVELOPER_GID} \
               -G users \
               -G sudo \
               --create-home developer \
    && chown -R developer:developer /rust \
    && echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/00-developer

# !!! Anything requiring root should happen before this point.
USER developer

VOLUME /code
WORKDIR /code

