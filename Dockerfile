FROM ubuntu:22.04
ARG VERSION
WORKDIR /build/lava
RUN apt update && apt install -y wget curl jq lz4
RUN VERSION=$(curl -s "https://api.github.com/repos/lavanet/lava/releases/latest" | jq -r ".tag_name") \
    && wget -O lavad "https://github.com/lavanet/lava/releases/download/${VERSION}/lavad-${VERSION}-linux-amd64" \
    && chmod +x lavad
ENV PATH=$PATH:/build/lava
ADD setup.sh .
RUN chmod +x setup.sh
ENTRYPOINT [ "./setup.sh" ]