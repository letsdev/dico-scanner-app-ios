#!/usr/bin/env groovy

@Library('ld-shared')
import de.letsdev.*

pipeline {
    agent {
        label 'xcode-11'
    }
    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder logRotator(numToKeepStr: '20')
        disableConcurrentBuilds()
    }
    environment {
        DERIVED_DATA_PATH = "JenkinsDerivedData"
        MAVEN_SETTINGS_LOCATION = '/Users/jenkins/.m2/settings.xml'
        XC_TEST_DESTINATION = 'platform=iOS Simulator,name=iPhone 11,OS=latest'
        MAVEN_OPTS = '-Xms256m -Xmx2048m -Djava.awt.headless=true'
        RELEASE_BRANCH = 'testflight-upload'
        VERSION = readMavenPom(file: 'DiCoScanner/ios/pom.xml').getVersion()
    }
    stages {
        stage('Build & Test') {
            when {
                not {
                    branch env.RELEASE_BRANCH
                }
            }
            steps {
                dir('DiCoScanner') {
                    sh "mvn clean install -P dico-scanner-inhouse " +
                            "'-Dios.derivedDataPath=${env.DERIVED_DATA_PATH}' " +
                            "'-Dios.xcTestsDestination=${env.XC_TEST_DESTINATION}'"
                }
            }
            post {
                success {
                    archiveArtifacts artifacts: '**/checkout/**/target/*.ipa',
                            fingerprint: true,
                            onlyIfSuccessful: true,
                            allowEmptyArchive: true,
                            excludes: 'checkout/**'

                    archiveArtifacts artifacts: '**/checkout/**/target/*.DSYM',
                            fingerprint: true,
                            onlyIfSuccessful: true,
                            allowEmptyArchive: true,
                            excludes: 'checkout/**'
                }
            }
        }
        stage('Release') {
            when {
                allOf {
                    branch env.RELEASE_BRANCH
                    expression { return !tagExist(env.VERSION) }
                }
            }
            environment {
                MAVEN_SETTINGS_LOCATION = '/Users/jenkins/.m2/settings.xml'
            }
            steps {
                dir('DiCoScanner') {
                    sh "mvn -B --settings ${env.MAVEN_SETTINGS_LOCATION} release:prepare release:perform " +
                            "-DcheckModificationExcludeList=" +
                            "\'**/*Info.plist,**/*.entitlements*,**/*.xcodeproj/**.*,**/xcodebuild.log," +
                            "**/xcodebuild-clean.log\' "
                }
            }
        }
    }
}
