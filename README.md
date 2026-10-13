# RMT — 2026foscar-competition ROS1 이식

`2026foscar-competition`의 ROS2 Humble 코드를 **ROS1 Noetic / Python 3.10 / catkin** 환경으로 이식하는 작업이다. 작업 브랜치는 `feat/ros1-port`이며, 독립 워크스페이스는 [`ros1-port/`](ros1-port/README.md)에 있다.

원본 알고리즘과 판단 규칙을 보존하고 ROS 실행 경계만 변경했다. Windows에서 코드 보존·기존 테스트·차등 비교를 수행했다. **실제 Noetic 빌드, ROS 통신 및 주행 동등성은 아직 미검증이다.**

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

## 검증 결과

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
- 실제 Noetic devel/install 빌드, 생성 메시지 직렬화, 전체 launch 옵션·종료·rosbag·TF, ROS clock pause/rewind/jump, callback 동시성·큐 overflow·watchdog, TCPROS 지연·손실·재연결·과부하를 확인해야 한다.
- GPU 추론과 동일 관측·입력 순서·판단 시각을 적용한 전체 미션 replay 및 시뮬레이터·차량 주행 검증이 남아 있다. 빌드 성공만으로 기능 동등성을 판정하지 않는다.

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

브랜치 출력이 `feat/ros1-port`인지 확인하고 스테이징 내역을 검토한 뒤 commit과 push를 실행한다. 이 문서 정리 과정에서는 commit과 원격 push를 실행하지 않았다.
