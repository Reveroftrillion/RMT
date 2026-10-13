# RMT — 2026foscar-competition ROS1 이식

원본 `2026foscar-competition/`을 보존하면서 ROS1 Noetic / Python3.10 / catkin으로 이식한 프로젝트다.
ROS1 기준 브랜치는 `feat/ros1-port`, 현재 식별자·문서 정리 브랜치는 `refactor/identifiers-docs`다.
개인이 Codex로 개발하며 기존 기능과 외부 인터페이스 호환성을 우선한다.

**현재 최우선 미해결 문제는 두 번째 교차로의 녹색 미채택이다.** 2026-10-13 기록에서 1번 교차로는
red95개→green26개와 GO 전환이 확인됐지만 2번은 red316개·green0개로 STOP을 유지했다.
전체 미션 및 ROS2/ROS1 실제 전송·주행 동등성은 아직 미검증이다.

## 현재 개발 안내

| 문서 | 용도 |
| --- | --- |
| [AGENTS.md](AGENTS.md) | Codex 작업 범위, 호환성·기록 보존·검증·Git 규칙 |
| [개인 개발 계획](ros1-port/docs/DEVELOPMENT_WORKFLOW.md) | 구조, 우선순위, Windows/Ubuntu 작업, 완료 기준과 세션 인계 |
| [ROS1 README](ros1-port/README.md) | 실제 구현·미션·신호 조건, 실행·종료·네트워크 명령 |
| [문서 분류](ros1-port/docs/MARKDOWN_INDEX.md) | 과거 팀 자료·현재 안내·검증 근거의 구분 |
| [이번 변경과 검사 결과](ros1-port/docs/IDENTIFIERS_DOCS_2026-10-13.md) | 지역변수 정리 범위와 성공·실패·미검증 항목 |

[개발계획서](개발계획서.md), [남은 할일](남은%20할일.md), [할일](할일.md)은 2026-09의 **과거 팀 개발 자료**다.
작성자·역할·출처·체크박스를 보존하며 미완료 항목을 현재 backlog로 자동 승계하지 않는다.
앞으로의 작업은 개발 목표·영향 파일·구현·검증·완료 기준으로 정리한다.

## 구현과 보존 범위

원본 7개 패키지와 `foscar_ros1` 어댑터로 독립 워크스페이스를 구성했다. 메시지 생성,
publisher/subscriber, timer, parameter, TF, launch, 빌드 및 리소스 경계를 이식했다.
미션 우선순위·상태 합성, 신호 기억, 회피·보행자, 회전교차로·고속도로·터널,
GPS/DR·복귀, 경로 추종·제어·watchdog·종료 동작을 보존 대상으로 삼는다.
계산식·튜닝·속도 제한·모델·지도·경로·ROI·메시지 의미와 좌표계를 이번 리팩터링에서 변경하지 않는다.
SCMC나 다른 RMT 구현으로 대체하지 않았다.

원본 보존 기준 커밋은 `a1ea82efbf8d5f165201b7f51bf8a141439fb8c7`이다.
기존 검증은 production Python104개 중78개 바이트 동일/26개 ROS 경계 변환, 테스트·fixture99개 동일,
원본530개 SHA256을 기록했다. 이 수치는 **지역변수 정리 전 검증 이력**이다.
정리 후의 의도된 차이는 기존 검사에서 실패로 남기고 역매핑 AST와 차등 비교로 별도 검증한다.
[원래 이식 변경 안내](ros1-port/docs/CHANGES.md)와 [이번 변경 기록](ros1-port/docs/IDENTIFIERS_DOCS_2026-10-13.md)을 구분한다.

## Windows 개발과 검사

Windows에서는 편집·구문·ROS 대역 단위 테스트·동일 입력 차등 비교·패키징 정적 검사를 수행한다.
ROS1/catkin/MORAI 실검증은 Ubuntu에서 수행하며 Windows 결과로 대신하지 않는다.
기존 Windows 검증은 workspace 내부 Python3.10.11을 사용했고 시스템 Python/PATH를 바꾸지 않았다.
당시 WSL·Docker·ROS·catkin이 없었고 Ubuntu `192.168.1.2:22` 연결은 3초 timeout이었다. 이는 과거 환경 기록이다.

새 PC에서 검증 interpreter 준비:

```powershell
python ros1-port/tools/bootstrap_windows310.py
python -m pip --python ros1-port/.python310/python.exe install -r ros1-port/tools/requirements-windows310.txt
```

저장소 루트에서 현재 리팩터링 검사:

```powershell
cd C:\Users\rever\Coding\RMT-ros1
git status --short
git branch --show-current
ros1-port/.python310/python.exe ros1-port/tools/check_identifier_refactor.py
ros1-port/.python310/python.exe ros1-port/tools/run_refactor_checks.py
git diff --check
```

새 runner는 결과를 매번 `ros1-port/verification/.work/identifier-refactor-*`에 저장한다.
기존 JSON과 SHA256 manifest를 덮어쓰지 않는다. 반환값0이어도 byte/boundary/preflight 실패 로그는 별도 확인한다.
기존 검사의 직접 재현 명령과 당시 결과는 [검증 기록](ros1-port/docs/verification.md)에 보존했다.
`.python310/`, 다운로드와 `.work/` 대용량 trace는 Git 제외다.

## Ubuntu MORAI 실행

2026-10-13 현장 구성은 `/home/foscar/RMT-ros1`, 이미지 `rmt-noetic-py310:local`, Linux host network다.
호스트 Python3.8 Noetic과 컨테이너 Python3.10 Noetic을 섞지 않는다.
원본 NumPy1.24.4/ONNX Runtime GPU1.23.2를 유지하며 native extension도 같은 Python으로 준비한다.
[Docker 안내](ros1-port/docker/README.md)와 [Noetic 환경](ros1-port/docs/NOETIC_ENVIRONMENT.md)을 참고한다.

Competition Vehicle Status는 **127.0.0.1 Host9088→Destination909**로 별도 Connect하며,
제어 명령의 MORAI 수신은 **9093**이다. Ego Status9111이나 제어 화면 Destination9082로 대체하지 않는다.
기존 실행·수신 포트 점유 확인 후 다음 수신 전용 launch 하나를 사용한다.

```bash
cd /home/foscar/RMT-ros1
bash ros1-port/docker/run.sh --receive-root \
  roslaunch docker/local.launch drive:=false bag:=true
```

직접 주행 명령은 기존과 같다. **사용자의 명시적 주행 지시가 있을 때만** 수신 전용 launch를 종료하고 실행한다.
MORAI Pause·기존 실행 종료·센서 수신을 확인하고 카메라/CUDA 초기화와 관찰 준비 후 Pause를 해제한다.
자동 단기 시험 도구를 붙이지 않는다.

```bash
bash ros1-port/docker/run.sh --receive-root \
  roslaunch docker/local.launch drive:=true bag:=true
```

원본 일반 경로 기본60km/h 설정을 사용한다. 정상 종료는 Pause 해제 상태에서 launch 터미널 Ctrl+C 한 번,
제동·Manual/P 인계 로그와 실제 속도0 확인 후 Pause다. 비상 시 즉시 MORAI Pause를 사용한다.
[네트워크·실행·종료 상세 및 과거 인계](ros1-port/README.md#2026-10-13-morai-실행과-다음-작업-인계)를 따른다.
Python3.10 native underlay의 catkin devel/install 명령은 [ROS1 빌드 안내](ros1-port/README.md#빌드와-실행)에 있다.

## 과거 검증 근거와 미해결 범위

| 수행 환경·근거 | 당시 결과와 한계 |
| --- | --- |
| [Windows 동작 비교](ros1-port/docs/verification.md) | 양쪽909개 PASS; trace35,608·수치3,657,429·최대 차이0. 최초908 PASS/1 FAIL과 대역 상수 보완 후 재실행 이력 보존 |
| Windows 어댑터·패키징 | adapter26 PASS/1 native skip, 보조8 PASS; launch 인자110·노드21·typed parameter106·bag24+2·resource/message21 정적 확인 |
| [합성 ONNX](ros1-port/docs/model-comparison.json) | 이미지3개 raw/decode/신호 차이0, 검출 없음, CPU fallback. 실제 녹색 정확도·GPU 주행 검증 아님 |
| [Ubuntu Docker](ros1-port/docs/NOETIC_DOCKER_VALIDATION.md) | devel/install, 실제 메시지·TF, adapter27/27, GPU session/추론 확인. 전체 launch/미션·전송 동등성은 미검증 |
| [짧은 주행](ros1-port/docs/MORAI_SHORT_DRIVE_2026-10-13.md) | 실제 주행 일부·정지 확인; 최초 bag 유실과 실패 기록 보존 |
| [Competition 복구](ros1-port/docs/MORAI_STATUS_FOLLOWUP_2026-10-13.md) | 재연결 후181바이트345개/8초, parse 오류0 및 drive=false ROS 상태·위치·TF 확인 |
| [교차로2 분석](ros1-port/docs/morai-signal-hold-2026-10-13/bag-analysis.json) | red316/green0, 새 red age0.064초, STOP, stop_s312.8735, v_max0. 원본/box 영상이 없어 원인 미확정 |

실수 비교 기준은 `abs(a-b) <= max(1e-12, 1e-12*max(abs(a),abs(b)))`이며 상태·정수·bool·순서는 정확 일치다.
이 결과는 테스트 입력에서의 관측이며 모든 운행 상황의 동등성 증명은 아니다.

- 모델 README 해시와 실제 모델 해시 불일치로 preflight 실패를 유지한다. 기대값·모델을 바꾸지 않는다.
- 원본 CRLF 바이트와 Linux checkout 차이, 센서 장착/좌표 조건, camera 종료 traceback, bag 파일명 개행 문제가 남아 있다.
- Camera-7 실제640×480/pitch340°와 원본1280×720/pitch335°를 대조해야 한다. 원본 위치/FOV는 미확인이다.
- 영상→YOLO box→ROI→신호 선택→Behavior→DrivingTarget을 같은 시각으로 검증한다. ROI·confidence·기억·watchdog을 바꿔 출발시키지 않는다.
- 전체 launch, ROS clock pause/rewind/jump, callback 동시성·overflow, TCPROS 지연·손실·재연결·과부하, 모든 미션 replay/주행이 남아 있다.

자세한 오류는 [KNOWN_ISSUES](ros1-port/docs/KNOWN_ISSUES.md), 후속 검증은 [ROS1_INTEGRATION](ros1-port/docs/ROS1_INTEGRATION.md)에 있다.
2026-10-13 마감·정지·커밋/push 내역은 [WORK_LOG](ros1-port/docs/WORK_LOG_2026-10-13.md)의 과거 기록이다.
당일17:58 KST 조회의 실행 종료 상태는 새 세션의 차량 상태 확인을 대신하지 않는다.

## Git 관리

`origin`은 `https://github.com/Reveroftrillion/RMT.git`이다. 작업 목적별 브랜치에서 변경 파일과 검사 결과를 검토한다.
과거 `origin/feat/ros1-port` 업로드 지시는 당시 작업에 한정된다. **이번 작업은 자동 commit/push/main 병합을 하지 않는다.**
새 push 및 main 병합에는 별도 지시가 필요하다. 커밋 시 실제 변경 파일을 지정하고 `git diff --cached --stat`,
`git diff --cached --check`를 확인한다. build/devel/install, bag·대용량 로그, Docker 이미지와 artifacts는 업로드하지 않는다.
