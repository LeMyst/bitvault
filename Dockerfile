FROM rust:latest AS builder

WORKDIR /app

RUN apt update && apt install -y ca-certificates tzdata

COPY . .

RUN cargo build --release

FROM bitnami/minideb:latest

WORKDIR /app

RUN mkdir -p /usr/share/zoneinfo

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY --from=builder /app/target/release/bitvault /usr/bin/bitvault

EXPOSE 8080

CMD ["bitvault"]