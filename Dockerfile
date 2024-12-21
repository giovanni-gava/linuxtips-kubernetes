# Use a imagem oficial do Ubuntu como base
FROM ubuntu:latest

# Mantenedor da imagem (opcional)
LABEL maintainer="giovanni-gava"

# Atualizar os pacotes do sistema, instalar dependências e neovim
RUN apt-get update && \
    apt-get install -y wget unzip curl \
    openssh-client iputils-ping groff nano telnet neovim git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Definir a versão do Terraform
ENV TERRAFORM_VERSION=1.10.0

# Baixar e instalar Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Criar a pasta /shared como um ponto de montagem para um volume
RUN mkdir /shared
VOLUME /shared

# Criar a pasta Downloads e instalar o AWS CLI
RUN mkdir Downloads && \
    cd Downloads && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    cd .. && \
    rm -rf Downloads && \
    mkdir -p /root/.aws && \
    touch /root/.aws/credentials

# Definir o comando padrão para execução quando o container for iniciado
CMD ["/bin/bash"]
