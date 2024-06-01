FROM otel/opentelemetry-collector

# Create a user if it does not exist, or modify the existing user
# Replace 'otel' with the correct username found from inspecting the image
RUN groupadd -g 10001 docker && \
    usermod -aG docker 10001

# Copy your configuration file
COPY config-opentelemetry.yaml /etc/otel/config.yaml

ENTRYPOINT ["otelcol", "--config", "/etc/otel/config.yaml"]
