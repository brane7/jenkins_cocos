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
                script {
                    // Git 경로 명시적으로 설정
                    def gitExe = "C:\\Program Files\\Git\\cmd\\git.exe"
                    def repoUrl = "https://github.com/brane7/jenkins_cocos.git"
                    def branch = "main"
                    
                    // 작업 디렉터리 확인
                    echo "Current directory: ${pwd()}"
                    bat "dir"
                    
                    // Git 저장소 클론 또는 업데이트
                    if (fileExists('.git')) {
                        echo "Updating existing repository..."
                        bat "${gitExe} fetch origin"
                        bat "${gitExe} checkout ${branch}"
                        bat "${gitExe} reset --hard origin/${branch}"
                    } else {
                        echo "Cloning repository..."
                        bat "${gitExe} clone -b ${branch} ${repoUrl} ."
                    }
                    
                    // 체크아웃 확인
                    bat "${gitExe} status"
                    bat "${gitExe} log -1"
                }
            }
        }
        
        stage('Build with Cocos') {
            agent any
            steps {
                script {
                    echo "템플릿: ${params.TEMPLATE_KEY}, Cocos 버전: ${params.COCOS_VERSION}"
                    echo "Cocos Creator로 빌드 실행 중..."
                    
                    // PATH 환경 변수에 System32 추가
                    def currentPath = env.PATH ?: ""
                    env.PATH = "C:\\Windows\\System32;${currentPath}"
                    
                    echo "Updated PATH: ${env.PATH}"
                }

                
            
                script {
                    echo "Current directory: ${pwd()}"
                    echo "Checking CMD_Build directory..."
                    bat "dir CMD_Build"
                    echo "Running build script..."
                    bat "CMD_Build\\cmd_build.bat ${params.TEMPLATE_KEY} ${params.COCOS_VERSION}"
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

