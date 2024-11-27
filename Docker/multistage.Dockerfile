FROM alpine:3.15

# Set Energi version and checksum
ENV ENERGI_VERSION=v1.1.8
ENV ENERGI_CHECKSUM="6dad5d8d9d7190ca822a3779b334fa5b36da174518f9b51f09658af0a6364c02"

# Install required packages and create user
RUN apk add --no-cache \
    curl \
    ca-certificates \
    tzdata \
    && addgroup -S energiuser \
    && adduser -S -G energiuser energiuser \
    && mkdir -p /home/energiuser/.energicore3 \
    && chown -R energiuser:energiuser /home/energiuser

# Switch to non-root user
USER energiuser
WORKDIR /home/energiuser

# Download and install Energi Core
RUN curl -LO "https://s3-us-west-2.amazonaws.com/download.energi.software/releases/energi3/${ENERGI_VERSION}/energi3-${ENERGI_VERSION}-linux-amd64.tgz" \
    && echo "${ENERGI_CHECKSUM}  energi3-${ENERGI_VERSION}-linux-amd64.tgz" | sha256sum -c - \
    && tar xzf energi3-${ENERGI_VERSION}-linux-amd64.tgz \
    && mv energi3-${ENERGI_VERSION}-linux-amd64 energi3 \
    && rm energi3-${ENERGI_VERSION}-linux-amd64.tgz

# Expose P2P port (TCP and UDP)
EXPOSE 49797/tcp
EXPOSE 49797/udp

# Copy and set entrypoint
COPY --chown=energiuser:energiuser entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]