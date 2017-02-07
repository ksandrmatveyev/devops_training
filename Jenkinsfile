#!groovy
node{
    deleteDir()
    stage('cloneRepo'){
        git branch: 'task3', credentialsId: '2e21e2cc-a7b2-4657-85d6-7f867b231080', url: 'https://github.com/ksandrmatveyev/devops_training.git'
    }
    stage('buildIncVersion'){
        sh('chmod +x gradlew && ./gradlew setBuildVersion && ./gradlew build')
    }
	def vers = sh(returnStdout: true, script: "cat gradle.properties | grep -Po 'version=\\K(\\w+).(\\w+).(\\w+)'").trim()
	echo "vers=$vers"
    stage('pushChanges'){
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: '2e21e2cc-a7b2-4657-85d6-7f867b231080', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
            sh('git config --global user.name "Aleksandr Matveyev"')
            sh('git config --global user.email ksandr.matveyev@gmail.com')
            sh("git commit -am \"from Jenkins. Build - ${vers}\"")
            sh('git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/ksandrmatveyev/devops_training.git task3')
        }
    }
    stage('publishToNexus'){
        withCredentials([usernamePassword(credentialsId: '20fd7e9f-9aa1-4ae8-924b-90cf8dde2099', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USERNAME')]) {
            dir('build/libs'){
                sh "curl -v -u $NEXUS_USERNAME:$NEXUS_PASSWORD --upload-file task3.war \"http://172.20.20.32:8081/nexus/content/repositories/training/task3/${vers}/task3.war\""
            }
        }    
    }
    stage('deployToTomcat1'){
        withCredentials([usernamePassword(credentialsId: '42921b32-7177-4d87-af6b-282d6d41aa6c', passwordVariable: 'TOMCAT_PASSWORD', usernameVariable: 'TOMCAT_USERNAME')]) {
            httpRequest httpMode: 'POST', url: 'http://172.20.20.33/jkstatus/?cmd=update&from=list&w=loadbalancer&sw=tomcat1&vwa=1'
            sh "curl \"http://172.20.20.32:8081/nexus/content/repositories/training/task3/${vers}/task3.war\" | curl -T - -u $TOMCAT_USERNAME:$TOMCAT_PASSWORD \"http://172.20.20.34:8080/manager/text/deploy?path=/testapp/task3&update=true\""
            sleep 60
            def tom1 = sh(returnStdout: true, script: "curl -s http://172.20.20.34:8080/testapp/task3/ | grep -Po 'version=\\K(\\w+).(\\w+).(\\w+)'").trim()
            echo "tomcat1=$tom1"
            if(vers==tom1){
                echo "versions are the same"
                httpRequest httpMode: 'POST', url: 'http://172.20.20.33/jkstatus/?cmd=update&from=list&w=loadbalancer&sw=tomcat1&vwa=0'
            }
            else {
                echo "versions are different"
                currentBuild.result = 'FAILURE'
            }
        }
    }
    stage('deployToTomcat2'){
        withCredentials([usernamePassword(credentialsId: '42921b32-7177-4d87-af6b-282d6d41aa6c', passwordVariable: 'TOMCAT_PASSWORD', usernameVariable: 'TOMCAT_USERNAME')]) {
            httpRequest httpMode: 'POST', url: 'http://172.20.20.33/jkstatus/?cmd=update&from=list&w=loadbalancer&sw=tomcat2&vwa=1'
            sh "curl \"http://172.20.20.32:8081/nexus/content/repositories/training/task3/${vers}/task3.war\" | curl -T - -u $TOMCAT_USERNAME:$TOMCAT_PASSWORD \"http://172.20.20.35:8080/manager/text/deploy?path=/testapp/task3&update=true\""
            sleep 60
            def tom2 = sh(returnStdout: true, script: "curl -s http://172.20.20.35:8080/testapp/task3/ | grep -Po 'version=\\K(\\w+).(\\w+).(\\w+)'").trim()
            echo "tomcat2=$tom2"
            if(vers==tom2){
                echo "versions are the same"
                httpRequest httpMode: 'POST', url: 'http://172.20.20.33/jkstatus/?cmd=update&from=list&w=loadbalancer&sw=tomcat2&vwa=0'
            }
            else {
                echo "versions are different"
                currentBuild.result = 'FAILURE'
            }
        }
    }
}
