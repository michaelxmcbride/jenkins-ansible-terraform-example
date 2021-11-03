FROM jenkins/jenkins:2.303.2-jdk11

# Switch to root user to install system packages.
USER root

# Install base packages.
RUN apt-get update && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common

# Install Docker CE CLI.
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
        "deb [arch=$(dpkg --print-architecture)] \
        https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli

# Install Ansible.
RUN add-apt-repository \
        "deb [arch=$(dpkg --print-architecture)] \
        http://ppa.launchpad.net/ansible/ansible/ubuntu \
        focal main"
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN apt-get update && apt-get install -y ansible

# Install Terraform.
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository \
        "deb [arch=$(dpkg --print-architecture)] \
        https://apt.releases.hashicorp.com \
        $(lsb_release -cs) main"
RUN apt-get update && apt-get install -y terraform

# Switch to Jenkins user to install Jenkins plugins and start Jenkins instance.
USER jenkins

# Install Jenkins plugins.
RUN jenkins-plugin-cli --plugins "blueocean:1.25.0 docker-workflow:1.26"
