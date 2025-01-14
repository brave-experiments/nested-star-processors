FROM rust:1@sha256:ec7dae306d01d4c52d2b6cce4a62a8da2f2e54df543e527e1656ae7c4ef632b3

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
