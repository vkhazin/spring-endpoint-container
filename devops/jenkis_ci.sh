#!/usr/bin/env bash

# 1. We need command line interface to work with Jenkins from terminal. Get it with same filename.
JENKINS_URL="http://127.0.0.1:8080"
curl -O ${JENKINS_URL}/jnlpJars/jenkins-cli.jar

# 2. We need admin account credentials to have an access via cli
JENKINS_ADMIN_NAME="admin"
JENKINS_ADMIN_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

# 3. Install plugins
PLUGINS=""
# 3.1 Post-Build Script - plugin will allow to execute scripts on the Jenkins host after the build has completed without errors.
# We need this so we can deploy our Java JAR after it has been packaged
PLUGINS="$PLUGINS postbuildscript"

# 3.2 Pipeline Plugin - for building continous delivery
# https://wiki.jenkins.io/display/JENKINS/Pipeline+Plugin
PLUGINS="$PLUGINS workflow-aggregator"

# 3.3 Docker Pipeline Plugin - Allows to build and use Docker containers from pipelines.
# https://wiki.jenkins.io/display/JENKINS/Docker+Pipeline+Plugin
PLUGINS="$PLUGINS docker-workflow"

# 3.4 BitBucket Plugin to use webhook
PLUGINS="$PLUGINS bitbucket"

# 3.5 CloudBees Docker Custom Build Environment
PLUGINS="$PLUGINS docker-custom-build-environment"

# 3.6 AWS credentials
PLUGINS="$PLUGINS aws-credentials"

# 3.7 Dashboard view
# https://wiki.jenkins.io/display/JENKINS/Dashboard+View
PLUGINS="$PLUGINS dashboard-view"

# 3.8 Pipeline Stage View
# https://wiki.jenkins.io/display/JENKINS/Pipeline+Stage+View+Plugin
PLUGINS="$PLUGINS pipeline-stage-view"


# 3.9 Installation of plugins
# JENKINS CLI command https://gist.github.com/amokan/3881064
for CURRENT_PLUGIN in $(echo ${PLUGINS});
do {
    echo "Installation of plugin \"${CURRENT_PLUGIN}\" start ->"
    java -jar jenkins-cli.jar -s ${JENKINS_URL} install-plugin ${CURRENT_PLUGIN} --username "$JENKINS_ADMIN_NAME" --password "$JENKINS_ADMIN_PASSWORD"
    echo "Installation of plugin \"${CURRENT_PLUGIN}\" finish <-"
}
done

# Add access rights to jenkins to docker using
sudo service jenkins restart

# Check that jenkins is up
echo "Jenkins via public ip = https://$(curl ifconfig.co -s)"
echo "Jenkins via public dns =  https://$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)"
echo "Jenkins admin password: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"