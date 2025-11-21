pipeline {
    agent any
    
    parameters {
        choice(
            name: 'TEMPLATE_KEY',
            choices: ['gas', 'kb', 'devpnp'],
            description: '빌드 템플릿 선택'
        )
        choice(
            name: 'COCOS_VERSION',
            choices: ['387', '384'],
            description: 'Cocos Creator 버전 선택'
        )
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Git 저장소에서 소스 코드 체크아웃 중...'
                // 명시적으로 Git 저장소 체크아웃
                git branch: 'main',
                    url: 'https://github.com/brane7/jenkins_cocos.git',
                    credentialsId: ''
            }
        }
        
        stage('Build with Cocos') {
            steps {
                script {
                    echo "템플릿: ${params.TEMPLATE_KEY}, Cocos 버전: ${params.COCOS_VERSION}"
                    echo "Cocos Creator로 빌드 실행 중..."
                }
                // 컨테이너 환경에서 cmd.exe를 명시적으로 호출
                //bat "C:\\Windows\\System32\\cmd.exe /c \"${WORKSPACE}\\CMD_Build\\cmd_build.bat\" ${params.TEMPLATE_KEY} ${params.COCOS_VERSION}"
                bat "echo %PATH%"
            }
        }
        
        stage('Archive Build Result') {
            steps {
                script {
                    def buildDir = "build/${params.TEMPLATE_KEY}"
                    if (fileExists(buildDir)) {
                        echo "빌드 결과물 아카이브 중: ${buildDir}"
                        archiveArtifacts artifacts: "${buildDir}/**", fingerprint: true, allowEmptyArchive: false
                    } else {
                        error "빌드 결과물을 찾을 수 없습니다: ${buildDir}"
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ 빌드 성공!'
        }
        failure {
            echo '❌ 빌드 실패!'
        }
        always {
            echo '빌드 파이프라인 완료'
        }
    }
}