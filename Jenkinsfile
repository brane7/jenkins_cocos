pipeline {
    agent none
    
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
            agent any
            steps {
                echo 'Git 저장소에서 소스 코드 체크아웃 중...'
                checkout scm
            }
        }
        
        stage('Build with Cocos') {
            agent any
            steps {
                script {
                    echo "템플릿: ${params.TEMPLATE_KEY}, Cocos 버전: ${params.COCOS_VERSION}"
                    echo "Docker 컨테이너에서 빌드 실행 중..."
                    
                    // Docker 컨테이너에서 빌드 실행
                    // cocos-builder의 SHELL이 PowerShell이므로 cmd.exe를 명시적으로 경로 지정
                    bat """
                        docker run --rm -v "${WORKSPACE}:C:/app" -w C:/app company/cocos-builder:3_8_7 C://Windows//System32//cmd.exe /c "CMD_Build//cmd_build.bat ${params.TEMPLATE_KEY} ${params.COCOS_VERSION}"
                    """
                }
            }
        }
        
        stage('Archive Build Result') {
            agent any
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

