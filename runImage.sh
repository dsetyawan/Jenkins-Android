mkdir /data/jenkins-android
sudo chown -R 1000:1000 /data/jenkins-android
sudo docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v /data/jenkins-android:/var/jenkins_home dsetyawan/jenkins-android:1.0
