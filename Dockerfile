FROM jenkins/jenkins:lts as jenkins-plugins

USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

USER jenkins 

# Disable setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# https://github.com/jenkinsci/docker/#preinstalling-plugins
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

#
# Caching plugins installation (which takes time)
#
FROM jenkins-plugins
# https://plugins.jenkins.io/configuration-as-code/
#
# If CASC_JENKINS_CONFIG points to a folder, 
# the plugin will recursively traverse the folder to find file(s) with .yml,.yaml,.YAML,.YML suffix. 
# It will exclude hidden files or files that contain a hidden folder in any part of the full path. 
# It follows symbolic links for both files and directories.
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc_configs

# For CASC configs, see https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos
# RUN mkdir -p /var/jenkins_home/casc_configs
# COPY casc/* /var/jenkins_home/casc_configs/
