# 2026foscar-competition ROS1 port

원본 `../2026foscar-competition`을 비교 기준으로 보존한 독립 catkin 워크스페이스다. SCMC나 다른 RMT 구현을 가져오지 않았다. 작업 브랜치는 `feat/ros1-port`, 기준 커밋은 `a1ea82efbf8d5f165201b7f51bf8a141439fb8c7`이다. 원격 push는 하지 않았다.

이식 코드와 Windows에서 가능한 검증을 제공한다. 실제 Noetic 빌드·ROS 통신·시뮬레이터 주행까지 동등성이 입증된 상태는 아니다.

변경 경로는 [파일 안내](docs/CHANGES.md), 검증 수치와 범위는 [검증 결과](docs/verification.md)에 정리했다.

저장소 전체 작업 요약과 GitHub 업로드 명령은 [루트 README](../README.md)에 있다.

## 검증 요약

| 항목 | 결과 |
| --- | --- |
| 원본 파일 | 530개 해시 일치, 원본 수정 없음 |
| production Python | 78개 바이트 동일, 26개 ROS 경계 변환 재현 |
| 기존 테스트 | 원본·이식본 각각 909개 통과; 테스트 대역 보완 후 실패 case 재실행 이력 포함 |
| 차등 비교 | trace 35,608개, 수치 3,657,429개, 최대 절대 차이 0 |
| 실행 어댑터 / 패키징 보조 테스트 | 26개 통과·1개 skip / 8개 통과 |
| 실제 ONNX | 합성 이미지 3개, CPU fallback에서 출력 차이 0; 검출 객체 없음 |
| preflight | 원본 모델 README 해시 불일치로 실패 유지 |
| 실제 ROS·GPU·주행 | 미검증 |

실수 허용 오차는 `abs(a-b) <= max(1e-12, 1e-12*max(abs(a),abs(b)))`이며 상태·정수·bool·순서는 정확 비교한다. 차등 비교는 테스트 메시지와 Node 대역을 사용하고 어댑터 검사는 fake rospy transport/time을 사용한다. 실제 ROS 전송·직렬화·실행 스케줄링 동등성은 별도 검증이 필요하다.

## 변경 범위와 보존 근거

- 원본 `src/` 전체와 모델·지도·경로·ROI·YAML·메시지·기존 테스트를 복사했다. 리소스와 메시지 정의의 원본 바이트를 유지한다.
- `.gitattributes`로 이식본의 자동 줄바꿈 변환을 막았다. 원본의 보정 경로 해시는 현재 Windows CRLF 바이트를 기준으로 하므로 Linux checkout에서도 해당 바이트를 보존한다.
- ROS 경계 변경은 [tools/port_boundary.py](tools/port_boundary.py)의 재현 가능한 변환으로 제한했다. 계산식, 조건문, 상태 우선순위, 속도·정지·해제·reset 값은 바꾸지 않았다. [verification/check_preservation.py](verification/check_preservation.py)가 전체 원본 해시와 허용된 변환을 검사한다.
- `foscar_interfaces`는 같은 네 메시지를 catkin `message_generation`으로 생성한다. ROS1의 timestamp `secs/nsecs`로 필드 이름만 바꾼다. 단위·좌표계·차량 기준점은 그대로다.
- [src/foscar_ros1](src/foscar_ros1/README.md)은 `rospy` 수신을 큐에 넣고 원본 executor 방식으로 판단 콜백을 실행한다. 기본 상호 배제 group, behavior의 별도 events group과 두 worker, KEEP_LAST 깊이, timer 우선 탐색을 유지한다. TF 수신도 obstacle executor를 통한다.
- 원본 ROS clock과 `time.monotonic()`/wall time을 구분한다. 센서 timestamp, 판단 시각, timer 주기, watchdog·UDP 송신·종료 handoff 계산은 유지한다.
- ROS2 YAML은 수정하지 않는다. launch의 `_ros2_parameter_files`를 어댑터가 읽고, dotted parameter 이름은 ROS1 private 이름에서 `/`로 표현한다. 타입 검사와 원본 오류·보정 경로 해시 검사를 유지한다.
- Humble PointCloud2 읽기·생성 코드를 고정 commit과 함께 재사용하며 ROS1 byte 직렬화만 맞췄다. Humble/Noetic Quaternion 기본값 차이는 Marker 생성 어댑터로 보존했다.
- catkin install의 리소스 경로는 `rospkg`로 찾는다. 고속도로 곡률 캐시 파일도 같은 패키지 `config/highway_kappa.npz`를 가리킨다.

실행 진입점은 [run_competition.sh](run_competition.sh)와 [competition.launch](src/foscar_bringup/launch/competition.launch)다. 필수 제어·위치·FSM 노드 종료 시 전체 launch 종료, 카메라 5초 지연, bag 기록·포인트 기록 옵션과 토픽을 유지한다. `competition`, `low_speed`, `obstacle`, `drive`, `yolo_signal`, `gps_record`의 ROS1 XML을 제공한다. 복사한 `*.launch.py`는 원본 비교·기존 테스트용이며 catkin 설치 대상에서 제외한다. 대회에서 실행하지 않는 `camera_train`의 offline 수집 launch는 ROS1 실행 검증 범위 밖이다.

## 선택한 대상 환경

사용자 결정: **Python 3.10으로 빌드한 ROS1 Noetic**, 원본 `numpy==1.24.4`와 `onnxruntime-gpu==1.23.2` 유지. 표준 Ubuntu 20.04의 Python 3.8용 Noetic 바이너리를 Python 3.10에서 그대로 사용할 수 있다고 가정하면 안 된다. `tf2` 등 Python native extension을 포함해 같은 interpreter로 빌드해야 한다. [대상 환경 준비 및 검사](docs/NOETIC_ENVIRONMENT.md)를 참조한다.

TCPROS 어댑터를 후보로 유지하고 실제 지연·손실 재현 검증 후 전송 동등성을 판단하기로 했다. DDS BEST_EFFORT와 TCPROS의 차이를 큐 어댑터만으로 해결했다고 판단하지 않는다.

## 빌드와 실행

Python 3.10과 일치하는 Noetic underlay 및 원본 의존성을 먼저 준비한 Linux에서:

```bash
cd ros1-port
source /opt/ros/noetic/setup.bash
catkin_make -DPYTHON_EXECUTABLE="$(command -v python3.10)"
source devel/setup.bash
python3.10 tools/check_noetic_environment.py
bash run_competition.sh drive:=false
```

원본과 동일하게 `bash run_competition.sh`의 기본값은 **`drive:=true`**다. 기존 `camera`, `lidar`, `lidar_sim`, `rviz`, `view`, `bag`, `bag_points`, route/config/states 및 미션 옵션은 XML의 인자 그대로 전달한다. 카메라 모델은 원본 파일을 그대로 사용한다.

설치 공간도 별도로 검증해야 한다:

```bash
catkin_make install -DPYTHON_EXECUTABLE="$(command -v python3.10)"
source install/setup.bash
roslaunch --nodes foscar_bringup competition.launch drive:=false
```

## Windows 검증

현재 PC에는 WSL, Docker, `roscore`, `catkin_make`, `rospy`, `rclpy`가 없었다. 문서에 기록된 Ubuntu 시뮬 PC `192.168.1.2:22`는 연결 검사에서 3초 timeout이었다. 연결 가능한 ROS 실행 환경을 확인하지 못했다.

원본 고정 의존성과 같은 Python 3.10.11 검증 interpreter를 `.python310/`에 준비했다. 시스템 Python·PATH는 변경하지 않았다. 이 환경은 Git에서 제외하며 ROS1 설치를 대신하지 않는다. 다른 Windows PC에서는 아래로 같은 검증 환경을 재구성할 수 있다. 공식 Python 배포본 checksum을 검사하며 전체 검증 의존성은 별도 파일에 고정했다.

```powershell
python ros1-port/tools/bootstrap_windows310.py
python -m pip --python ros1-port/.python310/python.exe install -r ros1-port/tools/requirements-windows310.txt
```

저장소 루트에서:

```powershell
python ros1-port/tools/check_packaging.py
python ros1-port/tools/port_boundary.py
python ros1-port/verification/check_preservation.py
ros1-port/.python310/python.exe -m unittest discover -s ros1-port/src/foscar_ros1/test -v
ros1-port/.python310/python.exe ros1-port/verification/run_differential.py
ros1-port/.python310/python.exe ros1-port/tools/check_model_equivalence.py
python ros1-port/tools/preflight.py
```

`preflight.py`는 원본 README의 모델 해시 불일치를 탐지해 현재 실패한다. 이 검사를 삭제하거나 모델·README의 원본을 변경하지 않았다. [원본 문제 및 미검증 항목](docs/KNOWN_ISSUES.md)을 참조한다.

검증 결과와 수치 허용 오차는 [verification 결과 문서](docs/verification.md), [동작 비교 결과](verification/differential-results.json), [모델 비교 결과](docs/model-comparison.json)에 기록한다. 계산·상태 비교에서 쓰는 테스트 메시지 대역은 실제 ROS 직렬화·전송의 증거와 구분한다.

## 남은 검증

[통합 검증 절차](docs/ROS1_INTEGRATION.md)에 따라 Noetic devel/install 빌드, 실제 생성 메시지 직렬화, 전체 launch 옵션과 종료, `/clock`, TF, 지연·손실·과부하, GPU 추론 및 동일 관측·판단 시각을 사용한 모든 미션 주행 replay를 확인해야 한다. 빌드 성공만으로 기능 동등성을 판정하지 않는다.
