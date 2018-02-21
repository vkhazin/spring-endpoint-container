# Install using rpm packages:
JAVA_VERSION=1.8.0
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum update -y 
sudo yum install jenkins java-${JAVA_VERSION}-openjdk-headless -y
sudo alternatives --set java /usr/lib/jvm/jre-${JAVA_VERSION}-openjdk.x86_64/bin/java
sudo service jenkins restart
echo "Pausing for a bit to let Jenkins service start..."
sleep 20 # jenkins-cli download fails otherwise

# Install required plug-ins:
JENKINS_URL="http://127.0.0.1:8080/"
USERNAME="admin"
PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

curl $JENKINS_URL/jnlpJars/jenkins-cli.jar -o jenkins-cli.jar
PLUGINS="dashboard-view bitbucket docker-custom-build-environment docker-plugin workflow-cps momentjs pipeline-model-declarative-agent pipeline-input-step handlebars pipeline-build-step pipeline-stage-view git-server ace-editor workflow-cps-global-lib workflow-multibranch workflow-job pipeline-stage-tags-metadata durable-task pipeline-graph-analysis jackson2-api pipeline-stage-step workflow-durable-task-step pipeline-model-definition ssh-slaves workflow-basic-steps jquery-detached token-macro pipeline-model-extensions workflow-support docker-java-api pipeline-rest-api pipeline-model-api pipeline-milestone-step workflow-aggregator docker-workflow"

for PLUGIN in $(echo ${PLUGINS}); do
    java -jar jenkins-cli.jar -s $JENKINS_URL install-plugin ${PLUGIN} --username "$USERNAME" --password "$PASSWORD"
done

# Grant docker permissions to Jenkins user
sudo groupadd docker
sudo usermod -a -G docker jenkins
sudo service docker restart
sudo service jenkins restart

PUBLIC_IP=$(curl ipinfo.io/ip)
echo "Login into Jenkins: https://$PUBLIC_IP, using password: $PASSWORD, ignore certificate warning, and skip setup!"
