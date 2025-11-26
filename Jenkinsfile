pipeline {
    agent any
    
    environment {
        // Windows PATH 환경변수 설정 (cmd.exe를 찾기 위해)
        PATH = "C:\\WINDOWS\\SYSTEM32;C:\\WINDOWS;C:\\WINDOWS\\System32\\Wbem;${env.PATH}"
        // Cocos Creator 관련 환경 변수 (SYSTEM 계정 문제 해결)
        COCOS_CREATOR_NO_UPDATE_CHECK = "1"
        NODE_OPTIONS = "--max-old-space-size=4096"
        // 사용자 프로필 경로 설정 (SYSTEM 계정이 아닌 경우)
        USERPROFILE = "${env.USERPROFILE}"
        APPDATA = "${env.APPDATA}"

        ELECTRON_DISABLE_SANDBOX = '1'
        ELECTRON_NO_ATTACH_CONSOLE = '1'
    }
    
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
                    echo "워크스페이스 경로: ${WORKSPACE}"
                    
                    // 빌드 전 시스템 리소스 확인
                    bat """
                        @echo off
                        echo === 시스템 리소스 확인 ===
                        systeminfo | findstr /C:"Total Physical Memory" /C:"Available Physical Memory"
                        echo.
                        echo === 디스크 공간 확인 ===
                        dir ${WORKSPACE} | findstr "bytes free"
                        echo.
                    """
                }
                // PATH 환경변수가 설정되었으므로 cmd.exe를 직접 사용 가능
                // 타임아웃 설정 (60분) 및 상세 로그 출력
                timeout(time: 60, unit: 'MINUTES') {
                    bat """
                        @echo off
                        echo === Cocos Creator 빌드 시작 ===
                        call "${WORKSPACE}\\CMD_Build\\cmd_build.bat" ${params.TEMPLATE_KEY} ${params.COCOS_VERSION}
                        set BUILD_EXIT_CODE=%ERRORLEVEL%
                        echo === 빌드 종료 코드: %BUILD_EXIT_CODE% ===
                        if %BUILD_EXIT_CODE% NEQ 0 (
                            echo 빌드 실패: exit code %BUILD_EXIT_CODE%
                            exit /b %BUILD_EXIT_CODE%
                        )
                    """
                }
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