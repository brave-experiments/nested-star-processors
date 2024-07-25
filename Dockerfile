FROM rust:1@sha256:9b2689d6f99ff381f178fa4361db745c8c355faecde73aa5b18b0efa84f03e62

EXPOSE 8080 9090

WORKDIR /usr/src/app

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -rf ./aws

# install paginator for aws stepfunctions cli
RUN apt update && apt install -y less

COPY ./src ./src
COPY ./migrations ./migrations
COPY ./Cargo.toml .
COPY ./Cargo.lock .

COPY ./misc/rds_iam_bootstrap /usr/local/bin/

RUN cargo build --release
RUN cp ./target/release/constellation-processors /usr/local/bin/

RUN cargo clean
RUN rm -rf /usr/local/cargo/registry

CMD ["constellation-processors"]
