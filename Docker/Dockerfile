# Use an official Ubuntu base image with no vulnerabilities for compatibility with Energi documentation
FROM ubuntu:24.10 AS downloader

# Install necessary tools for downloading and checksum verification
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user and set up directory structure
RUN addgroup -S energigroup && adduser -S energiuser -G energigroup && \
    mkdir -p /home/energiuser/energi3/bin /home/energiuser/energi3/js && \
    chown -R energiuser:energiuser /home/energiuser/energi3

# Switch to non-root user
USER energiuser

# Set Energi version and checksum
ENV ENERGI_VERSION=v1.1.8
ENV ENERGI_CHECKSUM="6dad5d8d9d7190ca822a3779b334fa5b36da174518f9b51f09658af0a6364c02"

# Set working directory
WORKDIR energi3/bin

# Download Energi Core and verify checksum
RUN curl -LO https://s3-us-west-2.amazonaws.com/download.energi.software/releases/energi3/${ENERGI_VERSION}/energi3-${ENERGI_VERSION}-linux-amd64.tgz \
    && echo "Download complete. Verifying checksum..." \
    && echo "${ENERGI_CHECKSUM}  energi3-${ENERGI_VERSION}-linux-amd64.tgz" | sha256sum -c - || exit 1 \
    && echo "Checksum verified. Extracting files..." \
    && tar xzf energi3-${ENERGI_VERSION}-linux-amd64.tgz \
    && rm energi3-${ENERGI_VERSION}-linux-amd64.tgz

# Expose necessary ports for TCP and UDP
EXPOSE 49797

# Copy entrypoint script
COPY entrypoint.sh /home/energiuser/entrypoint.sh
RUN chmod +x /home/energiuser/entrypoint.sh

ENTRYPOINT ["/home/energiuser/entrypoint.sh"]