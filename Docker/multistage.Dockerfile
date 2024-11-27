# Use an official Ubuntu base image with no vulnerabilities for compatibility with Energi documentation
FROM ubuntu:24.10 AS downloader

# Install necessary tools for downloading and checksum verification
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set Energi version and checksum
ENV ENERGI_VERSION=v1.1.8
ENV ENERGI_CHECKSUM="6dad5d8d9d7190ca822a3779b334fa5b36da174518f9b51f09658af0a6364c02"

# Set working directory
WORKDIR /energi3

# Download Energi Core and verify checksum
RUN curl -LO https://s3-us-west-2.amazonaws.com/download.energi.software/releases/energi3/${ENERGI_VERSION}/energi3-${ENERGI_VERSION}-linux-amd64.tgz \
    && echo "Download complete. Verifying checksum..." \
    && echo "${ENERGI_CHECKSUM}  energi3-${ENERGI_VERSION}-linux-amd64.tgz" | sha256sum -c - || exit 1 \
    && echo "Checksum verified. Extracting files..." \
    && tar xzf energi3-${ENERGI_VERSION}-linux-amd64.tgz \
    && rm energi3-${ENERGI_VERSION}-linux-amd64.tgz

# Use an official Ubuntu base image for runtime
FROM ubuntu:22.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates net-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up non-root user and required directories
RUN useradd -ms /bin/bash energi && \
    mkdir -p /home/energi/.energicore && \
    chown -R energi:energi /home/energi

# Copy the binary from the downloader stage
COPY --from=downloader /downloads/energi3 /usr/local/bin/

# Set binary permissions
RUN chmod +x /usr/local/bin/energi3

# Switch to non-root user
USER energi

# Set working directory
WORKDIR /home/energi

# Expose necessary ports
# 8545: JSON-RPC API, 39797: P2P communication
EXPOSE 8545 39797

# Healthcheck for JSON-RPC API
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD /bin/bash -c 'netstat -an | grep LISTEN | grep 8545 || exit 1'

# Command to run Energi node with customizable options
ENTRYPOINT ["energi3"]
CMD ["--rpc", "--rpcaddr", "${RPC_ADDR:-0.0.0.0}"]