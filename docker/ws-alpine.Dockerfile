FROM alpine:3.15

ARG UID=1000
ARG GID=1000
ARG HOST_USER=exegete
ENV DOCKER=true

RUN apk add --no-cache \
  build-base \
  bash \
  curl \
  docker \
  fzf \
  github-cli \
  httpie \
  openssl-dev \
  ripgrep \
  ruby-builder \
  sudo \
  vim \
  zsh \
  && rm -Rf /usr/bin/vi && ln -s /usr/bin/vim /usr/bin/vi

# Setup local user.
RUN adduser -D -s /bin/zsh -u ${UID} -g root ${HOST_USER}
RUN echo "${HOST_USER} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${HOST_USER} \
    && chmod 0440 /etc/sudoers.d/${HOST_USER}
USER ${HOST_USER}

# Setup ASDF.
COPY install-asdf.sh /tmp/
RUN /tmp/install-asdf.sh

COPY --chown=${HOST_USER} ./ /home/${HOST_USER}/dotfiles
WORKDIR /home/${HOST_USER}/dotfiles
RUN /bin/zsh ./install.sh

WORKDIR /home/${HOST_USER}
RUN touch .auto_tmux

CMD ["/bin/zsh"]
