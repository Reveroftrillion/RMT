# ROS1 / MORAI 실행 안내

현재 상태와 미션별 결과는 [루트 README](../README.md),
[최신 검증 범위](docs/CURRENT_STATUS_2026-10-22.md)를 먼저 확인한다.
2026-10-22 오른쪽 정적·보행자 수정본의 사용자 전체 코스 FINISH를 bag으로 확인했다.
직전 터널 정지와 공식 감점/무충돌/종료 인계의 미확인 범위는 그대로 남아 있다.

## 환경 구축

현재 실검증 환경은 Ubuntu의 `rmt-noetic-py310:local` Docker 이미지다.
[Docker 환경 구성](docker/README.md), [Noetic 환경](docs/NOETIC_ENVIRONMENT.md),
[기존 native 검증](docs/NOETIC_DOCKER_VALIDATION.md)을 참고한다.

```bash
cd /home/foscar/RMT-ros1
bash ros1-port/docker/build.sh
bash ros1-port/docker/run.sh bash docker/build_workspace.sh
```

첫 명령은 Docker 이미지·GPU/underlay 준비 조건이 필요하며 네트워크 다운로드를
포함할 수 있다. 기존 이미지/빌드가 있으면 매 주행마다 다시 만들지 않는다.
코드는 bind mount되며 새 모듈/빌드 변경 시 워크스페이스를 재빌드한다.
ROS1 메시지·TF·토픽·포트·단위와 원본 데이터는 유지한다.

## MORAI 준비

같은 `2026_molit_comp_sample_scene.json`을 로드하고 원래 Ego 시작점,
Pause 해제·Manual/P로 준비한다. Reset/장면 로드 후 채널이 끊길 수 있으므로
화면에서 다시 Connect하고 실제 수신으로 확인한다.

| 채널 | 현재 호스트 설정 |
| --- | --- |
| Competition Vehicle Status | 127.0.0.1:9088 → 127.0.0.1:909 |
| Ego Ctrl Cmd | MORAI 수신9093 |
| Collision Data | 출력 목적지9092 |
| GPS / IMU | 수신1111 / 1112 |
| VLP16 / Camera-7 | 수신2368 / 9297 |

Ego Status9111을 Competition Status909 대신 사용하지 않는다.
기존 ROS/master/기록기를 중복 기동하지 않는다. MORAI의9088/9093 점유는 정상이다.

## 시작점부터 실행

```bash
cd /home/foscar/RMT-ros1
bash ros1-port/docker/run_course.sh drive:=false bag:=true
```

Status·센서·위치·TF·target을 확인하고 이 실행을 Ctrl+C로 종료한다.
drive=false는 ROS 제어 요청을 만들 수 있지만 bridge UDP 송신을 허용하지 않는다.
송신0개의 엄밀한 증거가 필요하면 [verify_live.py](docker/verify_live.py)의
passive capture를 사용한다. 센서가 들어온다는 것만으로 UDP0을 판정하지 않는다.

실제 MORAI 시뮬레이터 주행:

```bash
bash ros1-port/docker/run_course.sh drive:=true bag:=true
```

기동 직후 출발 가능. 직접 실행에는 충돌·이탈·무진행 자동 종료 감독이 없다.
감독 시험은 [audit_course.py](docker/audit_course.py)와
[기존 감독 조건](docs/FULL_COURSE_AUDIT_2026-10-22.md)을 사용한다.
이 문서 작업에서 실제 주행을 시작하지 않았다.

현재 실행은 START 반경3m 안의 첫 랩 전용이다. 정확히 같은 좌표 하나를
요구하지 않지만 반경 밖에서 s0을 강제로 부여하지 않는다. 실패 시 원래
시작점으로 Reset한다. 중간 위치 수신 점검은 다음처럼 별도 실행한다:

```bash
bash ros1-port/docker/run.sh --receive-root \
  roslaunch docker/local.launch drive:=false bag:=true
```

## 종료·기록

정상 종료는 실행한 터미널에서 Ctrl+C 한 번. 실제 속도0과
`shutdown handoff confirmed: Manual/P, brake released`를 확인한다.
인계 실패 로그가 있으면 성공으로 취급하지 않는다. 비상 시 MORAI Pause를
사용하되 Pause 상태 자체는 제동·인계 증거가 아니다.

각 실행은 호스트 `ros1-port/docker/artifacts/manual-*`를 새로 만든다.
console.log 원문 전체, ROS 로그, follower CSV, 기본 상태/인지/계획/제어 bag,
원본 GPS/IMU/LiDAR/raw·debug 카메라/TF bag을 보존한다.
`raw:=false`는 추가 원본 기록기만 끄고 `bag:=false`는 기록기를 모두 끈다.
YOLO JSONL은 기존 임시 경로가 남아 있어 이 래퍼가 영구 보존한다고 주장하지 않는다.
원본 bag 파일명 개행 문제도 남아 있으며 `ls -lb`로 확인한다.

화면에는 반복 상태/통계를5초, 같은 경고를10초 간격으로 표시한다.
상태 전환·ERROR/FATAL·인계는 즉시 표시하며 필터 전 문구는 console.log에 남긴다.
터미널 프롬프트의 `$`, 이어쓰기 프롬프트 `>`는 명령에 포함하지 않는다.

## 문제 구분

| 현상 | 먼저 볼 근거 |
| --- | --- |
| WAITING / pose 없음 | Status RX0인지, IMU·GPS만 수신되는지 |
| START radius FAULT | 현재 위치가 시작점 반경 안인지. 중간 재시작에 첫 랩 옵션을 썼는지 |
| AVOID v_max0 | 장애물·지도·곡선·BEV 관측 제약. 단순히 속도 제한을 높이지 않음 |
| NO_TARGET | planner 노드·입력 freshness·계산 공백 |
| FINISH | 경로/runout 종료. 이후 실제 속도·Manual/P 확인은 별도 |

## 검증·개발

[현재 작업 계획](docs/DEVELOPMENT_WORKFLOW.md),
[알고리즘·native 검사 요약](docs/verification-20261022/checks-summary.json),
[파일·미션 안내](docs/FILE_MISSIONS_2026-10-22.md),
[원래 이식 변경](docs/CHANGES.md)를 참고한다.

기존 README의 상세 실험·구현 설명은
[이전 안내 원문](docs/history/ROS1_README_before_2026-10-22.txt)에 보존했다.
해당 원문의 링크/명령은 당시 ros1-port/README.md 위치 문맥이며 현재 실행 지침과 구분한다.
원본 출처·작성자·라이선스는 각 소스/패키지의 선언을 유지한다.

<a id="2026-10-13-morai-실행과-다음-작업-인계"></a>
<a id="빌드와-실행"></a>

과거 문서의 실행/빌드 앵커는 호환성을 위해 유지한다. 현재 명령은 위 환경
구축·시작점 실행 절을 따르고, 10/13 당시 상세 기록은 이전 안내 원문을 참고한다.
