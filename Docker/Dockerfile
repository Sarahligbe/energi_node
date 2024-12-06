# Use an official Ubuntu base image with no vulnerabilities for compatibility with Energi documentation
FROM ubuntu:24.10

# Install necessary tools for downloading and checksum verification
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user and set up data directory
RUN addgroup --gid 1001 energiuser && adduser --uid 1001 energiuser --ingroup energiuser --disabled-password && \
    mkdir -p /home/energiuser/.energicore3 && \
    chown -R energiuser:energiuser /home/energiuser/.energicore3

# Switch to non-root user
USER energiuser

WORKDIR /home/energiuser

# Set Energi version and checksum from https://wiki.energi.world/docs/guides/core-node-linux#22-setup-auto-start
ENV ENERGI_VERSION=v1.1.8
ENV ENERGI_CHECKSUM="6dad5d8d9d7190ca822a3779b334fa5b36da174518f9b51f09658af0a6364c02"

# Download Energi Core and verify checksum
RUN curl -LO https://s3-us-west-2.amazonaws.com/download.energi.software/releases/energi3/${ENERGI_VERSION}/energi3-${ENERGI_VERSION}-linux-amd64.tgz && \
    echo "Download complete. Verifying checksum..." && \
    echo "${ENERGI_CHECKSUM}  energi3-${ENERGI_VERSION}-linux-amd64.tgz" | sha256sum -c - || exit 1 && \
    echo "Checksum verified. Extracting files..." && \
    tar xzf energi3-${ENERGI_VERSION}-linux-amd64.tgz && \
    mv energi3-${ENERGI_VERSION}-linux-amd64 energi3 && \
    rm energi3-${ENERGI_VERSION}-linux-amd64.tgz

# Expose necessary ports for TCP and UDP
EXPOSE 39797

# Copy entrypoint script
COPY --chown=energiuser:energiuser entrypoint.sh /home/energiuser/entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/home/energiuser/entrypoint.sh"]