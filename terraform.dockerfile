FROM alpine
MAINTAINER Nikoloz Jakhua

RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.4.4/terraform_1.4.4_linux_amd64.zip
RUN unzip /tmp/terraform.zip -d / && \ 
  mv terraform /usr/local/bin/terraform && \
  rm -f terraform_1.4.4_linux_amd64.zip
RUN apk add ca-certificates

ENTRYPOINT [ "terraform" ]
