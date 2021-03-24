# SONARQUBE-SLACK

To execute this Docker image.

```bash
docker image build -t sonarqube-slack .
docker image ls
docker run -d --name sonarqube-slack -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube-slack:latest
```