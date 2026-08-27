# Docker image for CHIP 3.3 (Intro to HTTP and URIs).
#
# The assignment is done entirely from the command line with curl and nc
# (netcat), so this image just guarantees those tools are present. Also used
# as the base for GitHub Codespaces via .devcontainer/devcontainer.json.
FROM ruby:3.3.8

# curl and nc are the two tools this assignment is built around -- install
# them explicitly rather than relying on the base image to provide them.
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY README.md ./

CMD ["bash"]
