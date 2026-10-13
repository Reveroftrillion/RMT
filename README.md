# RMT — 2026foscar-competition ROS1 이식

`2026foscar-competition`의 ROS2 Humble 코드를 **ROS1 Noetic / Python 3.10 / catkin** 환경으로 이식하는 작업이다. 작업 브랜치는 `feat/ros1-port`이며, 독립 워크스페이스는 [`ros1-port/`](ros1-port/README.md)에 있다.

원본 알고리즘과 판단 규칙을 보존하고 ROS 실행 경계만 변경했다. Windows 비교에 이어 2026-10-13 동아리 Ubuntu MORAI PC에서 Python 3.10 기반 Docker Noetic 빌드·실제 ROS 메시지/TF·GPU 추론·짧은 주행과 정지를 확인했다. **전체 미션 및 ROS2/ROS1 실제 전송·주행 동등성은 미검증이며, 두 번째 교차로에서 녹색을 채택하지 못하고 정지하는 문제가 남아 있다.**

## 내일 이어서 작업할 때 — 2026-10-13 실제 MORAI 인계

**자세한 연결 방법, 실행·종료, 현재 로직, 신호 정지 원인과 수정 순서는 [ROS1 README의 MORAI 인계 기록](ros1-port/README.md#2026-10-13-morai-실행과-다음-작업-인계)을 먼저 읽는다.**

- 작업 위치 `/home/foscar/RMT-ros1`, 브랜치 `feat/ros1-port`, 이미지 `rmt-noetic-py310:local`. 호스트 Python3.8용 Noetic 대신 컨테이너의 Python3.10용 Noetic을 사용한다.
- Linux host network, 양쪽 IP127.0.0.1. Competition Vehicle Status는 **Host9088→Destination909**로 별도 Connect한다. 제어 명령의 MORAI 수신은 **9093**이다. Ego Status9111과 제어 화면의 Destination9082로 대체하지 않는다.
- Competition 재연결 후 실제 181바이트 패킷345개/8초, 원본 파싱 오류0 및 drive=false ROS 상태/위치/TF를 확인했다. 이후 실제 일반 경로 주행에서도 센서 RX와 freshness는 유지됐다.
- 실제 bag에서 1번 교차로는 red95개→green26개와 GO 전환이 기록됐다. **2번은 red316개·green0개**, 종료 직전에도 새 red의 age0.064초, STOP, `stop_s=312.8735`, `v_max=0`이었다. 단순 UDP 연결 실패나 오래된 red만 남은 현상으로 설명되지 않는다.
- 다음 우선 작업은 Camera-7의 실제 영상·검출 box·ROI·신호 방향 대조다. 현재640×480/pitch340°는 원본1280×720/pitch335°와 다르다. 위치·FOV의 원본 값은 미확인이다. 인식 입력을 확인하기 전에 ROI·confidence·신호 기억·watchdog·미션값을 바꾸어 출발시키지 않는다.
- 사용자 Ctrl+C 로그에서 Manual/P 인계를 확인했다. 17:58 KST 마감 조회에서는 RMT 컨테이너·ROS/진단 프로세스와 MORAI 실행이 없었다. 새 차량 속도 피드백은 없어 과거 정지 확인과 구분한다.

오늘의 세 시험 결과, 커밋 범위와 로컬 실험 원본 위치는 [일일 마감 기록](ros1-port/docs/WORK_LOG_2026-10-13.md)에 정리했다.
업로드 대상은 `origin/feat/ros1-port`이며 `main`에는 합치지 않는다.

직접 주행 명령은 아래와 같다. **MORAI Pause 유지·기존 실행 종료·센서 수신 확인 후** 실행하고, 카메라/CUDA 초기화가 끝나 주행을 관찰할 준비가 되면 Pause를 해제한다. 자동 단기 시험 도구는 붙이지 않는다.

```bash
cd /home/foscar/RMT-ros1
bash ros1-port/docker/run.sh --receive-root \
  roslaunch docker/local.launch drive:=true bag:=true
```

실행 중 원본 기본60km/h 설정을 사용한다. 정상 종료는 Pause 해제 상태에서 launch 터미널 Ctrl+C 한 번,
제동·Manual/P 인계 로그와 실제 속도0 확인 후 Pause다. 비상 시에는 즉시 MORAI Pause를 사용한다.
이 명령으로 신호 인식 문제나 전체 미션 검증이 해결됐다고 판단하지 않는다.

## 작업 범위

- 원본 `2026foscar-competition/`은 수정하지 않고 비교 기준으로 보존했다. 기준 커밋은 `a1ea82efbf8d5f165201b7f51bf8a141439fb8c7`이다.
- SCMC나 다른 RMT 폴더 구현을 합치거나 대체하지 않았다. 기능 추가·개선·최적화와 원본 버그 수정은 범위에서 제외했다.
- 원본 7개 패키지와 `foscar_ros1` 실행 어댑터로 독립 catkin 워크스페이스를 구성했다. 메시지 생성, publisher/subscriber, timer, parameter, TF, launch, 빌드 및 리소스 경로를 이식했다.
- 모든 미션의 우선순위·동시 활성 제약, 신호등 색 기억과 교차로 정책, 회피 chain과 보행자 YIELD, 회전교차로·고속도로·터널 판단, GPS 음영·복귀, 경로 추종·제어·watchdog·종료 로직을 보존 대상으로 삼았다.
- 계산식·튜닝값·속도 제한·정지 및 reset 조건, 모델·지도·경로·ROI·파라미터, 메시지 의미·단위·좌표계·차량 기준점은 유지했다.
- 원본 `run_competition.sh`와 `competition.launch.py`를 기준으로 실행 구성을 옮겼다. launch 옵션과 활성 기본값, 카메라 5초 지연, bag 토픽 및 필수 노드 종료 처리를 유지했다. 기본 실행은 원본처럼 **`drive:=true`**다.

전체 변경 경로는 [변경 파일 안내](ros1-port/docs/CHANGES.md)에, 26개 Python 경계 변경 파일 목록은 [보존 검사 결과](ros1-port/verification/preservation-results.json)에 있다. `camera_train`의 offline 수집 launch는 대회 실행 경로에 포함되지 않으며 ROS1 실행 검증 범위 밖이다.

## 동작 보존 방식

순수 Python 계산 코드는 가능한 한 그대로 재사용했다. production Python 104개 중 78개는 원본과 바이트가 같고, 26개는 [명시적인 ROS 경계 변환](ros1-port/tools/port_boundary.py)으로 재현한다. 기존 테스트와 fixture 99개도 원본과 바이트가 같다. 원본 530개 파일은 SHA256 manifest로 검사한다.

[`foscar_ros1`](ros1-port/src/foscar_ros1/README.md)은 `rospy` 수신을 큐에 넣고 원본 callback group과 executor 방식에 맞춰 실행한다. 기본 상호 배제, behavior의 별도 events group과 두 worker, KEEP_LAST 깊이, timer 우선 탐색 및 TF 수신 경로를 보존한다. ROS time과 wall/monotonic time도 구분한다. PointCloud2는 고정된 Humble 구현을 재사용하고, Marker quaternion 기본값 차이는 최소 어댑터로 처리했다.

사용자가 선택한 전송 검증 방향은 **TCPROS 후보 유지 후 지연·손실 재현 검증**이다. 큐와 실행 어댑터만으로 DDS BEST_EFFORT와 TCPROS의 전송 의미가 같다고 판정하지 않는다.

## 기존 Windows 단계 검증 결과

| 검사 | 결과와 한계 |
| --- | --- |
| 원본 보존 | 원본 530개 파일 해시 일치, 원본 Git 변경 없음 |
| 기존 테스트 재사용 | 원본·이식본 각각 909개 통과. 최초 908개 통과 후 테스트 대역의 누락 상수만 보완하여 실패 case 재실행; 이력 보존 |
| 동일 입력·순서·판단 시각 비교 | trace 35,608개, 수치 3,657,429개 비교, 최대 절대 차이 0 |
| 상태·출력 비교 | 상태, 속도 상한, 정지점, 회피 chain, reference 및 제어 출력 비교. 실수 허용 오차는 아래 식, 상태·정수·bool·순서는 정확 일치 |
| 실행 어댑터 | 26개 통과, 실제 Noetic 메시지 직렬화가 필요한 1개 skip. transport/time은 fake rospy 사용 |
| 패키징 | 보조 테스트 8개 통과. launch 인자 110개, 노드 선언 21개, typed parameter 106개, 기본 bag 토픽 24개와 추가 2개 정적 확인 |
| 실제 ONNX 비교 | 고정 합성 이미지 3개에서 raw tensor·decode·신호 출력 차이 0. 검출 객체 없음. 양쪽 모두 원본 CPU fallback 사용; GPU 미검증 |
| preflight | **실패 유지**: 원본 모델 README의 해시와 실제 모델 해시 불일치 탐지 |
| catkin·ROS·주행 | 실행 환경이 연결되지 않아 미검증 |

실수 비교 기준은 `abs(a-b) <= max(1e-12, 1e-12*max(abs(a),abs(b)))`다. 테스트 입력에서 관측된 차이는 0이며, 이 결과는 모든 실제 운행 상황의 동등성을 증명하지 않는다. 차등 비교는 테스트용 ROS 메시지·Node 대역을 사용하므로 실제 ROS 전송·직렬화·스케줄링 검증과 구분한다.

[상세 검증과 재현 이력](ros1-port/docs/verification.md), [차등 비교 결과](ros1-port/verification/differential-results.json), [모델 비교 결과](ros1-port/docs/model-comparison.json)를 참고한다.

## 대상 환경과 실행

현재 동아리 Ubuntu PC에서는 위 인계 기록의 Docker 명령을 사용한다. 아래 native build 예시는
별도로 Python3.10용 Noetic underlay를 준비한 환경을 위한 것이며 호스트의 기존 `/opt/ros/noetic`을 뜻하지 않는다.

원본 `numpy==1.24.4`, `onnxruntime-gpu==1.23.2`를 유지하기 위해 **Python 3.10으로 빌드한 Noetic**을 선택했다. 표준 Python 3.8용 Noetic 바이너리와 혼용하지 않으며, `tf2` 등 native extension도 같은 Python으로 준비해야 한다. [환경 준비 절차](ros1-port/docs/NOETIC_ENVIRONMENT.md)를 먼저 확인한다.

일치하는 Noetic underlay와 원본 의존성을 준비한 Linux에서 실행한다. 아래 `/opt/ros/noetic`은 해당 underlay 설치 위치에 맞춘다.

```bash
cd ros1-port
source /opt/ros/noetic/setup.bash
catkin_make -DPYTHON_EXECUTABLE="$(command -v python3.10)"
source devel/setup.bash
python3.10 tools/check_noetic_environment.py
bash run_competition.sh drive:=false
```

설치 공간 확인:

```bash
catkin_make install -DPYTHON_EXECUTABLE="$(command -v python3.10)"
source install/setup.bash
roslaunch --nodes foscar_bringup competition.launch drive:=false
```

## Windows 검증 재현

확인 당시 개발 PC에 WSL·Docker·ROS·catkin이 없었고, 문서에 기록된 Ubuntu 시뮬 PC `192.168.1.2:22` 연결은 3초 timeout이었다. Windows 검증은 workspace 내부 Python 3.10.11에서 수행했으며 시스템 Python과 PATH는 변경하지 않았다.

저장소 루트에서:

```powershell
python ros1-port/tools/bootstrap_windows310.py
python -m pip --python ros1-port/.python310/python.exe install -r ros1-port/tools/requirements-windows310.txt
ros1-port/.python310/python.exe ros1-port/verification/check_preservation.py
ros1-port/.python310/python.exe ros1-port/tools/check_packaging.py
ros1-port/.python310/python.exe -m unittest discover -s ros1-port/src/foscar_ros1/test -v
ros1-port/.python310/python.exe ros1-port/verification/run_differential.py
ros1-port/.python310/python.exe ros1-port/tools/check_model_equivalence.py
ros1-port/.python310/python.exe ros1-port/tools/preflight.py
```

마지막 preflight는 아래 알려진 모델 해시 불일치로 현재 exit code 1을 반환한다. `.python310/`, 다운로드 파일 및 `verification/.work/`의 대용량 임시 trace는 Git에서 제외하며, 재현 도구와 결과 JSON은 포함한다.

## 알려진 문제와 남은 검증

- 원본과 이식본의 `best.onnx` 실제 SHA256은 `d3c3939f51cc8cfa19d0eefc815c3bb9eaae6533e795f8ff87f347e9ed048b98`이다. 원본 README의 기대값 `04ab171d8a46b5576891a23034000fa34cc63bf63336c8edb67b9a3fee551b8b`와 다르다. 모델 교체나 검사 삭제로 숨기지 않았다.
- 원본 경로 보정 해시는 Windows CRLF 바이트를 기준으로 한다. 이식본의 `.gitattributes`는 raw bytes를 보존한다. 줄바꿈 정규화나 보정 해시 변경을 하면 안 된다. 원본을 Linux에서 새로 checkout하면 바이트가 달라질 수 있으며, 기존 manifest를 덮어써서 통과시키지 않는다.
- Noetic devel/install 빌드·생성 메시지 직렬화·TF 및 실제 GPU session/추론은 [Linux 검증 기록](ros1-port/docs/NOETIC_DOCKER_VALIDATION.md)에 범위를 명시해 확인했다. 전체 launch 조합, ROS clock pause/rewind/jump, callback 동시성·큐 overflow, TCPROS 지연·손실·재연결·과부하는 별도 남은 검증이다.
- 이번 두 번째 교차로 신호 인식 문제, 센서 입력/좌표 차이, 동일 관측·입력 순서·판단 시각을 적용한 전체 미션 replay 및 주행 동등성 검증이 남아 있다. 짧은 주행이나 빌드 성공만으로 완주·동등성을 판정하지 않는다.

추가 원본 문제는 [알려진 문제](ros1-port/docs/KNOWN_ISSUES.md)에 기록했다. 실제 ROS 환경의 체크리스트는 [통합 검증 절차](ros1-port/docs/ROS1_INTEGRATION.md)에 있다.

## GitHub에 올리기

현재 `origin`은 `https://github.com/Reveroftrillion/RMT.git`, 작업 브랜치는 `feat/ros1-port`다. 아래 명령은 Windows PowerShell에서 사용한다. README와 이식 워크스페이스만 스테이징하며 원본 폴더는 포함하지 않는다.

```powershell
cd C:\Users\rever\Coding\RMT-ros1
git branch --show-current
git remote -v
git add -- README.md ros1-port/
git diff --cached --stat
git diff --cached --check
git commit -m "Port competition stack to ROS1 Noetic with behavior parity checks"
git push -u origin feat/ros1-port
```

브랜치 출력이 `feat/ros1-port`인지 확인하고 스테이징 내역을 검토한 뒤 commit과 push를 실행한다.
2026-10-13 일일 마감에서는 사용자가 이 브랜치의 commit/push를 명시 요청했다.
build/devel/install, Docker 이미지, bag·대용량 로그와 `ros1-port/docker/artifacts/`는 업로드 범위에서 제외한다.
