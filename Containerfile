FROM quay.io/fedora/fedora-minimal:40

COPY ./opentofu.repo /etc/yum.repos.d/opentofu.repo
# COPY .bashrc /root/.bashrc
RUN microdnf -y update && \
    microdnf install -y \
    python3 \
    python-devel \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    tar \
    gcc \
    python-argcomplete \
    openssh-clients \
    openssh-server \
    libssh-devel \
    sshpass \
    git \
    openssl \
    openssl-devel \
    java-17-openjdk-headless \
    krb5-devel \
    krb5-libs \
    krb5-workstation \
    ansible-core \
    tofu
RUN mkdir /pgvt-labnet-gha-iac
WORKDIR /pgvt-labnet-gha-iac
RUN python3 -m pip install --upgrade \
    pip
ADD ./requirements.txt /code/requirements.txt
ADD ./requirements.yml /code/requirements.yml
RUN python3 -m pip install -r /code/requirements.txt
RUN ansible-galaxy install -r /code/requirements.yml
RUN rm /code/requirements.txt /code/requirements.yml
RUN microdnf remove -y python3-setuptools python3-wheel && \
    microdnf clean all
RUN curl -sfL https://direnv.net/install.sh | bash
RUN eval "$(direnv hook bash)"
