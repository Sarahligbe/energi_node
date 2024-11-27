# Stage 1: Download and verify Energi binary
FROM ubuntu:24.10 AS downloader

# Set Energi version and checksum as build args for flexibility
ENV ENERGI_VERSION=v1.1.8
ENV ENERGI_CHECKSUM="6dad5d8d9d7190ca822a3779b334fa5b36da174518f9b51f09658af0a6364c02"

# Install minimal dependencies for downloading and verification
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /energi/download

WORKDIR /energi/download

# Download and verify Energi binary
RUN curl -LO "https://s3-us-west-2.amazonaws.com/download.energi.software/releases/energi3/${ENERGI_VERSION}/energi3-${ENERGI_VERSION}-linux-amd64.tgz" \
    && echo "${ENERGI_CHECKSUM}  energi3-${ENERGI_VERSION}-linux-amd64.tgz" | sha256sum -c - \
    && tar xzf "energi3-${ENERGI_VERSION}-linux-amd64.tgz" \
    && mv "energi3-${ENERGI_VERSION}-linux-amd64" /energi/binary \
    && rm -rf /energi/download

# Stage 2: Create runtime image
FROM ubuntu:24.10

# Install minimal runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user and group
RUN addgroup energiuser && adduser energiuser --ingroup energiuser --disabled-password \
    && mkdir -p /home/energiuser/.energicore3 \
    && chown -R energiuser:energiuser /home/energiuser

# Copy binary from downloader stage
COPY --from=downloader /energi/binary /usr/local/bin/energi3
RUN chmod +x /usr/local/bin/energi3

# Switch to non-root user
USER energiuser
WORKDIR /home/energiuser

# Copy entrypoint script
COPY --chown=energiuser:energiuser entrypoint.sh /home/energiuser/
RUN chmod +x /home/energiuser/entrypoint.sh

# Expose P2P port
EXPOSE 49797/tcp
EXPOSE 49797/udp

ENTRYPOINT ["/home/energiuser/entrypoint.sh"]