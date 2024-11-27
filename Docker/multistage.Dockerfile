# Stage 1: Downloader and Build Stage
FROM ubuntu:24.10 AS downloader

# Install necessary tools for downloading and checksum verification
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user for downloading and setup
RUN addgroup energiuser && adduser energiuser --ingroup energiuser --disabled-password && \
    mkdir -p /home/energiuser/.energicore3 && \
    chown -R energiuser:energiuser /home/energiuser/.energicore3

# Switch to non-root user
USER energiuser
WORKDIR /home/energiuser

# Set Energi version and checksum
ENV ENERGI_VERSION=v1.1.8
ENV ENERGI_CHECKSUM="6dad5d8d9d7190ca822a3779b334fa5b36da174518f9b51f09658af0a6364c02"

# Download Energi Core and verify checksum
RUN curl -LO https://s3-us-west-2.amazonaws.com/download.energi.software/releases/energi3/${ENERGI_VERSION}/energi3-${ENERGI_VERSION}-linux-amd64.tgz \
    && echo "Download complete. Verifying checksum..." \
    && echo "${ENERGI_CHECKSUM}  energi3-${ENERGI_VERSION}-linux-amd64.tgz" | sha256sum -c - || exit 1 \
    && echo "Checksum verified. Extracting files..." \
    && tar xzf energi3-${ENERGI_VERSION}-linux-amd64.tgz \
    && mv energi3-${ENERGI_VERSION}-linux-amd64 energi3 \
    && rm energi3-${ENERGI_VERSION}-linux-amd64.tgz

# Stage 2: Final Runtime Image
FROM ubuntu:24.10

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user for running the Energi node
RUN addgroup energiuser && adduser energiuser --ingroup energiuser --disabled-password && \
    mkdir -p /home/energiuser/.energicore3 && \
    chown -R energiuser:energiuser /home/energiuser/.energicore3

# Copy Energi Core binary from the downloader stage
COPY --from=downloader /home/energiuser/energi3 /usr/local/bin/energi3

# Copy entrypoint script
COPY entrypoint.sh /home/energiuser/entrypoint.sh
RUN chown energiuser:energiuser /home/energiuser/entrypoint.sh && \
    chmod +x /home/energiuser/entrypoint.sh
    

# Set ownership and permissions for the runtime directory
WORKDIR /home/energiuser
USER energiuser

# Expose necessary ports for TCP and UDP
EXPOSE 49797

# Set entrypoint
ENTRYPOINT ["/home/energiuser/entrypoint.sh"]