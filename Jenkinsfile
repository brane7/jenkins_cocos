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
                    // 명령어를 배열로 분리하여 가독성과 유지보수성 향상
                    def workspaceMount = "${WORKSPACE}:C:/app"
                    def batchFile = "CMD_Build\\cmd_build.bat"
                    def templateKey = params.TEMPLATE_KEY
                    def cocosVersion = params.COCOS_VERSION
                    
                    // 배열로 명령어 구성
                    // cocos-builder의 SHELL이 PowerShell이므로 --entrypoint로 cmd.exe를 직접 지정
                    def dockerArgs = [
                        'docker',
                        'run',
                        '--rm',
                        '--entrypoint', 'C:\\Windows\\System32\\cmd.exe',
                        '-v', workspaceMount,
                        '-w', 'C:/app',
                        'company/cocos-builder:3_8_7',
                        '/c',
                        "${batchFile} ${templateKey} ${cocosVersion}"
                    ]
                    
                    // 배열을 문자열로 결합 (공백으로 구분)
                    // Docker 명령 내부의 인자들은 따옴표로 감싸기
                    def dockerCommand = dockerArgs.collect { arg ->
                        // 공백이나 특수문자가 있는 인자는 따옴표로 감싸기
                        if (arg.contains(' ') || arg.contains(':')) {
                            "\"${arg}\""
                        } else {
                            arg
                        }
                    }.join(' ')
                    
                    echo "실행 명령: ${dockerCommand}"
                    // bat 블록에서 실행
                    bat dockerCommand
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

