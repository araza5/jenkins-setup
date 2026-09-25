FROM jenkins/jenkins:lts
USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Add Docker official GPG key
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository using VERSION_CODENAME from /etc/os-release
RUN . /etc/os-release && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian ${VERSION_CODENAME} stable" > /etc/apt/sources.list.d/docker.list

# Install Docker CLI
RUN apt-get update && apt-get install -y \
    docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Add jenkins user to docker group
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins