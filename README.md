# GN_Codyssey | 개발 워크스테이션 구축

> Windows + WSL 2 Ubuntu + Docker Desktop 환경에서 Linux CLI, 컨테이너, Git/GitHub를 실습하고 검증한 코디세이 입학연수 미션.

## 1. 전체 구성 및 진행 흐름

```text
Windows
 ├─ VS Code (WSL Ubuntu 터미널)
 ├─ WSL 2 → Ubuntu 26.04.1 LTS → Bash / Git 2.53.0
 └─ Docker Desktop → Docker Engine 29.9.2
                         ├─ hello-world / ubuntu:24.04
                         └─ NGINX 커스텀 웹 서버 :80
                             └─ localhost:8080 / localhost:8081
```

| 순서 | 핵심 작업 | 확인 방법 | 진행 |
|---|---|---|---|
| 1 | Linux CLI 및 파일 권한 | pwd, ls, cp, mv, rm, chmod | ✅ 실습 완료 |
| 2 | Docker 설치·점검 | docker --version, docker info | ✅ 실행 확인 / 성공 로그 보강 필요 |
| 3 | 기본 컨테이너 | hello-world, ubuntu, ps, logs, stats | ✅ 실행 확인 / 성공 로그 보강 필요 |
| 4 | Dockerfile 이미지 | docker build, docker images | ✅ 확인 |
| 5 | 포트 매핑 | localhost:8080, localhost:8081 | ✅ 실행 확인 / 브라우저 캡처 필요 |
| 6 | 바인드 마운트 | HTML 수정 전후 비교 | ⏳ 변경 전후 증거 보강 |
| 7 | Docker 볼륨 | 컨테이너 삭제 후 데이터 유지 | ✅ 로그 확인 |
| 8 | Git / GitHub | git push, 저장소 확인 | ✅ 업로드 확인 / 화면 캡처 필요 |

## 2. 실행 환경

| 항목 | 사용 환경 |
|---|---|
| 호스트 OS | Windows (세부 버전은 추후 확인) |
| Linux | WSL 2 + Ubuntu 26.04.1 LTS |
| 셸 | Bash |
| 편집기 | Visual Studio Code 1.143.0 |
| Git | Ubuntu Git 2.53.0 / Windows Git 2.50.0.windows.1 |
| Docker | Docker Desktop 4.97.0 / Docker CLI 및 Server 29.9.2 (업로드된 기본 점검 기록 기준) |
| 베이스 이미지 | nginx:alpine, ubuntu:24.04 |

## 3. 과제 산출물과 실행 기록

| 분류 | 파일 및 링크 | 확인 내용 |
|---|---|---|
| Linux 명령어 | [01-terminal.txt](evidence/logs/01-terminal.txt) | 경로·파일·폴더 조작 |
| 권한 변경 | [02-permission.txt](evidence/logs/02-permission.txt) | 파일 644→600→644, 디렉터리 755→700→755 |
| Docker 초기 점검 및 오류 | [03-docker-basic.txt](evidence/logs/03-docker-basic.txt) | Docker 정보와 초기 소켓 권한 오류. 성공 결과는 추가 기록 예정 |
| 이미지 빌드 | [04-dockerfile.txt](evidence/logs/04-dockerfile.txt) | gn-codyssey-web:1.0 빌드 성공 |
| 바인드 마운트 생성 | [05-bind-mount.txt](evidence/logs/05-bind-mount.txt) | 읽기 전용 바인드 마운트 컨테이너 생성. 변경 반영 결과 보강 필요 |
| 볼륨 검증 | [06-volume.txt](evidence/logs/06-volume.txt) | codyssey-data: 첫 컨테이너 삭제 후 새 컨테이너에서 Persistent Data 재확인 |
| 서버 설정 | [Dockerfile](Dockerfile) | NGINX 베이스, HTML COPY, 포트 80 |
| 서버 소스 | [app/index.html](app/index.html) | 정적 HTML 페이지 |
| 실습 예제 | [practice/](practice/) | Linux 실습용 파일 및 HTML 변경 전 백업 |

### 3.1 Linux 명령과 권한

```bash
pwd
ls -la
mkdir test
touch hello.txt
echo "Hello Codyssey" > hello.txt
cat hello.txt
cp hello.txt copy.txt
mv copy.txt renamed.txt
rm renamed.txt
chmod 600 hello.txt
chmod 644 hello.txt
chmod 700 test
chmod 755 test
rmdir test
```

| 권한 | 파일·디렉터리 표현 | 의미 |
|---|---|---|
| 600 | rw------- | 소유자만 읽기·쓰기 |
| 644 | rw-r--r-- | 소유자 읽기·쓰기, 기타 읽기 |
| 700 | rwx------ | 소유자만 디렉터리 접근 |
| 755 | rwxr-xr-x | 소유자 전체 권한, 기타 읽기·탐색 |

절대 경로 예: `/home/happyjihun/GN_Codyssey`. 상대 경로 예: `app/index.html` (프로젝트 루트 기준).

### 3.2 Docker 기본 동작

```bash
docker --version
docker info
docker images
docker ps
docker ps -a
docker run --name codyssey-hello hello-world
docker logs codyssey-hello
docker run -it --name codyssey-ubuntu ubuntu:24.04 bash
docker stats --no-stream
```

`hello-world`의 정상 종료는 `Exited (0)`로 확인했으며, Ubuntu 컨테이너 안에서 `pwd`, `ls`, `echo`를 실행했다. 이 성공 화면은 별도의 캡처로 확보했고 GitHub 성공 로그는 보강 예정이다.

### 3.3 직접 작성한 Dockerfile

```dockerfile
FROM nginx:alpine

LABEL org.opencontainers.image.title="GN-Codyssey-Web"

COPY app/ /usr/share/nginx/html/

EXPOSE 80
```

- `FROM`: 기존 NGINX 베이스 이미지 사용
- `LABEL`: 이미지 식별용 메타데이터
- `COPY`: 직접 만든 정적 웹 페이지 반영
- `EXPOSE 80`: 컨테이너 서비스 포트를 명시 (외부 공개 자체는 아님)

```bash
docker build -t gn-codyssey-web:1.0 .
docker run -d --name gn-codyssey-web -p 8080:80 gn-codyssey-web:1.0
docker run -d --name gn-codyssey-web-8081 -p 8081:80 gn-codyssey-web:1.0
curl http://localhost:8080
curl http://localhost:8081
```

`-p 8080:80`은 호스트의 8080번 포트를 컨테이너의 80번 포트로 연결한다. 8081도 동일한 이미지로 실행했다. 실제 브라우저 주소창을 포함한 스크린샷은 아직 README에 첨부하지 않았다.

### 3.4 바인드 마운트

```bash
docker run -d --name gn-codyssey-bind -p 8082:80 \
  --mount type=bind,src="$(pwd)/app",dst=/usr/share/nginx/html,readonly \
  gn-codyssey-web:1.0
curl http://localhost:8082
```

이 설정은 WSL의 `app/` 디렉터리를 NGINX의 웹 루트에 연결한다. 호스트의 HTML을 수정한 후 컨테이너를 다시 빌드하지 않고 반영되는지 **변경 전·후 출력과 캡처를 추가 검증할 예정**이다.

### 3.5 Docker 볼륨 영속성

```bash
docker volume create codyssey-data
docker run -d --name codyssey-vol-1 -v codyssey-data:/data ubuntu:24.04 sleep infinity
docker exec codyssey-vol-1 sh -c 'echo "Persistent Data" > /data/test.txt'
docker exec codyssey-vol-1 cat /data/test.txt
docker rm -f codyssey-vol-1
docker run -d --name codyssey-vol-2 -v codyssey-data:/data ubuntu:24.04 sleep infinity
docker exec codyssey-vol-2 cat /data/test.txt
```

첫 컨테이너와 두 번째 컨테이너에서 모두 `Persistent Data`가 출력되어, 컨테이너 수명과 별개로 볼륨 데이터가 보존됨을 확인했다.

## 4. Git과 GitHub

Git은 PC에서 변경 이력을 관리하는 도구이고 GitHub는 그 이력을 공유하는 원격 저장소다.

```bash
git status
git add .
git commit -m "Add Docker workstation practice results"
git push origin main
```

실제 저장소에 소스와 로그가 업로드되었음을 확인했다. Git 사용자 정보의 공개 범위, `git config --list` 검증, VS Code 연동 화면은 보강 예정이다.

## 5. 트러블슈팅

| 사례 | 문제 | 원인 가설·확인 | 해결 및 검증 |
|---|---|---|---|
| 1. Docker 권한 오류 | `permission denied ... /var/run/docker.sock` | `id -nG`에 docker 그룹 없음, 소켓은 root:docker | `sudo usermod -aG docker "$USER"`, WSL 재시작. 이후 `docker ps` 정상 작동 |
| 2. GitHub 인증 실패 | HTTPS Push 중 계정 비밀번호 요구 | GitHub에 CLI 인증 자격 증명이 미설정 | `gh auth login --web --git-protocol https`로 기기 인증, `gh auth setup-git`, `git push`로 업로드 확인 |

트러블슈팅은 실제 발생한 내용만 기록했다. 인증 코드나 비밀번호는 문서에 기재하지 않는다.

## 6. 남은 제출 증거

- [ ] Docker 기본 실습 성공 명령·출력을 별도 로그로 저장
- [ ] 바인드 마운트의 HTML 변경 전후 출력 및 화면
- [ ] 8080·8081 브라우저 접속 캡처 (주소창 포함)
- [ ] VS Code GitHub 연동 화면과 `git config --list` 검증 (민감정보 마스킹)
- [ ] 추가한 로그·스크린샷의 링크를 README에 반영
- [ ] 전체 명령어를 다시 재현 가능하게 최종 검토

> 주의: 로그에는 ANSI 제어 문자가 포함되어 있을 수 있다. 정확한 실행 흔적은 원본 로그로 유지하되 발표용에는 명령어와 핵심 출력만 선별한다.
