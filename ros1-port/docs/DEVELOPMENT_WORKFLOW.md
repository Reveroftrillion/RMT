# 개인 Codex 개발 계획과 인계

2026-10-23 현재 계획이다. [개발 규칙](../../AGENTS.md),
[ROS1 실행 안내](../README.md), [문서 분류](MARKDOWN_INDEX.md)를 따른다.
오늘 작업은 이 문서에 통합하며 과거 팀 계획·체크박스를 현재 미완료로 승계하지 않는다.

## 현재 위치

최신 게시 작업은 `release/ctrl-roundabout-20261023`에서 진행한다.
사용자가 현재 개발본 저장·GitHub 게시를 요청했다. 사용자 직접 완주2회의 FINISH·최종 속도 약0과
CSV SHA256을 새 [완주 기록·게시 기준](USER_FULLCOURSE_2026-10-23.md)에 남긴다.
목표·영향 파일·기능별 커밋·검증·완료 기준은 이 새 문서를 따른다.
기존 코드/README 변경을 보존하며 브랜치 push와 main 대상 PR 생성까지 진행한다.
이번 작업에서 main 병합이나 새 실제 MORAI 주행은 하지 않는다.

10/23 실행 안내 정리: 사용자가 호스트 `roslaunch ctrl_start.launch` 기준의 README 갱신을 요청했다.
브랜치는 `docs/ctrl-start-readme-20261023`이며 기존 미커밋 기능 변경은 보존한다.
목표는 현재 PC의 실행 명령을 첫 안내로 통일하는 것이다. 영향 파일은 루트/ROS1 README와 이 계획이다.
구현은 MORAI 준비·기존 터미널 source·수신 점검·기본 주행/기록·종료를 정리하고,
다른 PC 설치와 기존 Docker/bash 명령을 별도 절로 옮긴다.
검증은 실제 host_setup/launch 인자·기록 경로 대조, 내부 링크·문서 diff 검사,
기존 비문서 파일 해시 보존으로 한다. 완료 기준은 두 README의 일관된 실행 절차와 링크 통과다.
이번 문서 작업에서는 ROS 노드·MORAI·제어를 실행하지 않으며 과거 검사/실험 결과를 바꾸지 않는다.
완료: 두 README를 갱신했고 내부 링크62개·Bash 코드 블록15개 구문·git diff --check를 통과했다.
실제 launch의 drive/bag/raw 기본 true와 설치된 Bash 연결을 대조했으며 대상3문서 외
기존2,731개 파일의 SHA256 불변을 확인했다. 새 실제 주행·Windows·빌드 검사는 미실행이다.

최신 수정은 [로터리 s868.79m 정지·실제 재시험](ROUNDABOUT_WAIT_2026-10-23.md)이다.
현재 브랜치는 `fix/roundabout-wait-20261023`이다. 로터리 재질 지면 보정 누락을 수정해
감독 부분 주행1회에서 CP1~9·로터리 출구·s941.45 종료·원본 유효 충돌0·정지/Manual/P를 확인했다.
전체952 PASS/기존 ROUNDABOUT 고정 높이 정책 충돌1 FAIL이며 기대값은 보존했다.
이번 수정 후 전체 코스·다른 NPC 조건은 미시험이다. 이전 호스트 변경은 그대로 보존했고
이번 변경을 커밋·push·main 병합하지 않았다.

10/23 후속: [호스트 실행·사용자 추가 완주·현재 개발](HOST_ROSLAUNCH_2026-10-23.md)이 최신이다.
이전 변경은 PR #3으로 main `b0a0ee4`에 반영됐다. 사용자가 이후 직접 완주했다고 보고했고
최신 follower CSV의 FINISH·마지막 속도 약0을 확인했다. 공식 판정·감독 인계와 구분한다.
이번 브랜치는 `feat/host-roslaunch-20261023`이며 호스트 명령 연결·기록 개행·
카메라 정상 종료 처리를 진행한다. 아래 당시 준비/시험 기록과 최신 상태를 구분한다.

- 현재 개발: `ros1-port/`. 비교 원본: `2026_CTRL_competition/`.
  이전 개발본·계획·자료는 [과거자료](../../과거자료/README.md)에 보관했다.
- 10/22 동일 sample_scene 감독 시험2회에서 CP 전체·END, 원본 CollisionData 유효 충돌0,
  종료 후 정지·Manual/P 인계를 확인했다. 두 시험 종료 사유는 route_end_stopped다.
  공식 점수·차선·변형 조건의 통과로 확대하지 않는다. 사용자 요청으로 3차는 생략했다.
- 이전 터널 s1828.090m 정지 이력을 유지한다. 당시에는 raw LiDAR가 없었으나,
  오늘 새 raw 실패를 재현해 최소 수정·해당 조건1회 통과를 확인했다. 자세한 범위는 아래에 있다.
- 10/23 비교 원본 경로·현재 참조를 정리할 당시 Linux 검사에서 원본909/이식본944,
  어댑터27, 모델 비교는 통과했다. 차등 추적·식별자·리소스/메시지·manifest 검사는 실패다.
- 새 `ctrl_start.launch`와 기존 bash 래퍼 연결은 구성 검사3개를 통과한 뒤
  아래 오늘 결과의 실제 수신·주행·종료 시험까지 진행했다.
- 기존 미추적 `roslaunch`, `drive:=true`, 이동·이름 변경 및 사용자 변경은 보존한다.
  준비 당시 브랜치는 `cleanup/archive-legacy-20261023`이었고,
  현재 기능 수정 브랜치는 아래 오늘 결과에 명시한다.

## 오늘 진행 결과

- 새 ctrl_start.launch의 실제 수신 점검4회 PASS. 매번 센서·TF·target·기록·
  제어 UDP0·정상 종료를 확인했다.
- run-01: CP1~3 후 s249m, 전체 입력2.1~2.3초 공백으로 중단. 원인 미확정.
- run-02: s1827.520m TUNNEL/AVOID 정지 재현. 원본 LiDAR로 평면 지원영역 밖
  낮은 차선/가장자리 검출을 확인하고 지면 보정 지원영역을 최소 수정했다.
- 수정 후보 전체 알고리즘946 PASS·도구9 PASS. FAIL/skip0.
- run-03: 별도 s315.649 정적 거부로 중단. 같은 정적 입력 검출은 전후 동일,
  footprint 재생에서도 observed box conflicts with fixed course를 확인했다. 미해결.
- run-04: 같은 수정본으로 제공 CP·END·터널 통과, 원본 충돌16,210패킷 중 유효0,
  종료 후 정지·Manual/P31샘플/0.674초·자식 exit0. 수정본 완주1회다.
- 속도 단위 확인: run-02의 약116km/h와 run-04의84.3km/h는 raw Status와 GPS 변위가
  대체로 일치한다. highway 별도 상한36.1m/s가 있으며 이번에 속도 정책은 바꾸지 않았다.
- 현재 브랜치 `fix/tunnel-material-support-20261023`. 수정 후929개 고정 소스 변경0,
  실행 컨테이너0. commit/push/merge는 하지 않았다.
- [실제 시험과 실패 기록](CTRL_START_LIVE_2026-10-23.md) ·
  [수정·회귀·실증과 한계](TUNNEL_MATERIAL_EDGE_2026-10-23.md).

다음 우선은 아래 후속 정적 수정의 실제 재시험, 차선·공식 감점,
속도 정책과 대회 목표 정합성, 다른 조건 반복성이다. 터널 수정은 해당 조건1회
실주행 성공이며 모든 배치나 반복 안정성 해결로 표현하지 않는다.
기존 입력 중단·카메라 종료 traceback·배포/기록 문제도 유지한다.

## 후속 정적 정지 개발 결과

현재 브랜치는 `fix/static-stop-replay-20261023`이다. 새 source-before 스냅샷 대비
기존 파일 변경은 ground.py1개, 신규 검사 test_material_ground_reference.py1개다.
제동 중 지면 높이 중앙값과 원점 절편이 달라 유효 평면을 거부하는 경계를 확인했다.
median 방식이 실패했을 때만 같은 검증 기준으로 원점 높이 기준을 재시도한다.
기억·ROI·threshold·속도·watchdog·고정 우회 경로는 바꾸지 않았다.

- 실패183스캔 STATIC99에서 평면 추정 실패16→0, cap0 77→0. 실제 상자와 미관측 제약 보존.
- 성공618스캔 target618개 정확히 동일. 전체950·도구9 PASS, FAIL/skip0.
- **현재 추가 수정 후 실제 MORAI 주행은 미실행이다.** 위 run-04 성공을 합산하지 않는다.
- 다음 작업: START Reset·Manual/P·센서/Status/충돌 연결 확인 후 수신전용 검증,
  감독 실제 주행에서 정적 우회·터널·END·정지/인계를 확인한다.
- [원인·구현·재현·범위](STATIC_STOP_2026-10-23.md).

## 오늘 작업 순서

오늘 우선 목표는 새 실행 진입점의 실제 확인과 터널 실패 원인을 판별할 기록 확보였다.
아래는 시작 당시 순서·완료 기준이며 오늘 결과와 남은 항목은 위에 명시했다. 재현되지 않으면 성공을 기록하고 미해결로 남기며,
실패가 관측되면 해당 입력 분석·최소 수정·관련 회귀·재시험을 먼저 한다.
같은 기준 장면의 단순 반복 횟수를 늘리기 위해 자동 주행하지 않는다.

| 순서 | 개발 목표 | 영향 파일·입력 | 구현·검증 방법 | 완료 기준 |
| --- | --- | --- | --- | --- |
| 1 | 새 launch 실제 수신·기록·종료 | ctrl_start.launch, docker/run_course.sh, launch_info, 실제 센서·Status | drive=false로 센서·TF·target·bag/follower 생성 확인. 필요시 verify_live.py의 passive capture로 UDP9093 송신0 검증. 종료 후 잔존 프로세스·포트 확인 | 실제 환경에서 준비·기록·정상 종료 근거 확보. 새 launch 정적 PASS와 구분 |
| 2 | 터널 실패를 판별할 원본 확보 | raw.bag + 기본 bag의 pose/footprints/target/telemetry, 영상 | 시작점 준비·수신 확인 후 별도 주행 단계. s1750 이후 같은 stamp로 LiDAR·객체·후보 거부·제어 비교. 충돌/종료 판정은 별도 감독 근거 사용 | 정지 시 실물/지면/지도·BEV 거부 경계 특정. 미재현이면 기록만 보존하고 미해결 유지 |
| 3 | 재현 원인의 최소 수정 | ground.py, obstacle_node.py, planning/states/avoid.py, BEV/지도 모듈 중 원인이 입증된 파일만 | 실패 입력을 격리 재생해 경계를 고정하고 최소 수정. 해당 회귀·성공 입력 비교 후 실제 재시험 | 실패 원인 설명·수정 전후 재현·관련 회귀·실제 결과를 분리해 기록. 미재현이면 튜닝 보류 |
| 4 | 속도 기록의 의미 확인 | Status raw·follower CSV·odometry·분석 도구 | 이전 최고 기록 약118~123km/h를 단위 변환·수신값·같은 stamp 위치 변화와 대조. 실제 과속/추정 잡음/집계 문제 구분 | 속도값의 출처·단위·시간 구간 설명. 실패 경계 확인 전 제한값 변경 금지 |
| 5 | 차선·공식 감점 | 영상·TF·차체/바퀴 궤적·공식 판정 자료 | 정적 우회/복귀·고속도로·터널에서 차선 접촉 위치/시간을 확인하고 공식 판정과 대조 | 충돌0과 차선 판정을 분리. 공식 자료 미확보이면 미검증으로 명시 |
| 6 | 조건 변화·입력 경계 | 보행자/회전교차로/고속도로/터널 조건, stamp·camera gate·executor | 한 조건씩 바꾸고 기준 장면과 결과를 분리. 가림·재진입·끼어들기·급제동, 이후 재연결·pause/clock·지연/손실 시험 | 조건별 입력·실패·성공·복구 근거 확보. 오늘 남으면 후속으로 이월 |
| 7 | 기록·배포 정합성 | bag 이름·YOLO 로그·종료 예외·resource manifest·원본 CRLF | bag 이름 개행과 영구 로그 경로, traceback 원인을 개별 확인. 의도된 기능 변경과 원본 동등성 실패를 분류 | 과거 JSON/해시 기대값을 덮어쓰지 않고 현재 배포 검사 정책을 별도로 검토 |

## MORAI 준비와 첫 단계

사용자가 MORAI를 준비하는 동안에는 오프라인 조사·문서 정리만 진행한다.
초기 계획을 작성할 때는 노드를 실행하지 않았고, 이후 사용자 준비·시작 지시로
오늘 결과에 기록한 실환경 시험을 진행했다.

1. 같은 `2026_molit_comp_sample_scene.json`, 원래 START 반경3m 안, Manual/P 상태로 준비한다.
2. Competition Status 9088→909, 제어9093, Collision 목적지9092, GPS1111/IMU1112,
   VLP16 2368, Camera-7 9297을 연결한다. Reset 후 채널 연결을 재확인한다.
3. 기존 launch/master/기록기를 중복 기동하지 않는다.
4. 먼저 아래 수신전용으로 새 launch를 확인한다. 기본 무인자 launch는 drive=true이므로
   수신 점검에는 drive=false를 명시한다.

저장소 루트에서 Docker 터미널을 연다:

```bash
cd /home/foscar/RMT-ros1
bash ros1-port/docker/run.sh --receive-root
```

컨테이너 안에서 수신 점검:

```bash
roslaunch ctrl_start.launch drive:=false
```

별도 컨테이너 터미널에서 확인할 기본 명령:

```bash
rosnode list
rostopic hz /vehicle/status
rostopic hz /localization/odometry
rostopic hz /behavior/target
rosparam get /ros1_port/ctrl_start/run_dir
```

각 hz 관측은 Ctrl+C로 끝낸다. 수신·target 존재는 UDP 송신0의 증거가 아니다.
엄밀한 송신0 검사는 [verify_live.py](../docker/verify_live.py)의 passive capture를 사용한다.
정적 재확인은 `PYTHONDONTWRITEBYTECODE=1 /usr/bin/python3 ros1-port/tools/test_ctrl_start.py`다.

수신 점검을 종료하고 새 기록 폴더·시작점·Manual/P·충돌 연결을 확인한 다음,
별도 주행 단계에서 `roslaunch ctrl_start.launch`로 실행할 수 있다.
주행 중 코드 변경 금지. 직접 launch에는 자동 충돌·무진행 감독이 없다.
충돌·종료까지 판정하는 시험은 기존 audit_course.py 절차와 별도 원본 충돌 기록을 사용한다.
새 launch 구성과 감독 도구의 조합도 확인 후 사용한다.
[기존 감독 준비·검증 명령](STABILITY_AUDIT_2026-10-22.md#기록재현복구)을 참고한다.

## 남은 전체 과제와 우선순위

- P0: 차선·신호·충돌의 공식 감점 확인, 규정의 속도 예외 경계와 실제 궤적 대조.
  사용자 추가 완주를 반영해 같은 장면 완주 반복보다 점수·조건 변화 검증을 우선한다.
- P1: 다른 미션 배치·신호 시점·날씨, 보행자 가림/재진입/동물,
  회전교차로 간격·고속도로 끼어들기/급제동·터널 배치 변화.
- P1: 오래된 stamp, 센서 손실·재연결, camera gate, pause/clock 역행·정지, executor 부하.
- P2: 호스트 명령·bag 개행·카메라 종료 수정 후 실제 기동/기록/종료 확인,
  YOLO JSONL 영구 보존, 배포 리소스 해시·원본 줄바꿈·모델 문서.
- 기존 이동/원본 이름/launch 정리는 main에 반영했다. 이번 후속 변경은 별도 검토하며
  새 push/main 병합은 별도 명시 지시에 따른다.

## 기록·판정 원칙

### 10/23 GitHub 게시 작업

- 개발 목표: 사용자 요청으로 오늘까지의 변경을 GitHub와 main의 현재 개발 기준에 반영한다.
- 영향 파일: 과거 자료·비교 원본 경로, 실행 launch/래퍼, 지면 인식 수정·검사,
  현재 안내와 날짜별 검증 요약. bag·Docker artifacts·로컬 환경과 기존 미추적 빈 파일은 제외한다.
- 구현 방법: 자료 정리, launch, 터널 수정, 정적 수정과 현재 안내를 별도 커밋으로 나눈다.
  원격 main을 확인하고 PR의 변경·검증 범위를 남긴 뒤 병합한다. 강제 push는 사용하지 않는다.
- 검증 방법: 이동한2,205개 파일의 Git blob 일치, 검사한 src/tools SHA256 일치,
  구문·현재 문서 링크·JSON 해석, staged diff와 CRLF-aware whitespace 검사를 확인한다.
  기존 알고리즘950·도구9 PASS는 앞선 오프라인 수행 결과이며 이번 게시 작업에서
  실제 MORAI 재시험·Windows·catkin 배포 검사를 새로 수행한 것으로 표현하지 않는다.
- 완료 기준: 원격 main에 게시 커밋 반영 확인, 로컬 잔여 변경 확인 및 PR/커밋 보고.
  최신 정적 수정은 실제 재시험 전이고, 과거 원본 동등성/리소스 기준 실패도 유지한다.

새 실험마다 새 출력 경로를 사용하고 과거 문서·JSON·SHA256·모델·경로·기대값을 바꾸지 않는다.
각 작업은 목표·영향 파일·원인·구현·검증·완료 기준을 남긴다. 실패·skip·미실행을 보고한다.
실패 경계 확인 전에 threshold·ROI·신호 기억·watchdog·속도 제한을 바꾸지 않는다.
기능 변경 없는 정리와 기능 수정을 분리하고 실제 차량 제어는 별도 명시 승인 대상이다.
Windows·ROS1/native·MORAI 검사 범위를 구분한다. 과거 Ubuntu 성공을 오늘 수행으로 쓰지 않는다.

10/23 준비 시점 디스크 여유는 약1.1TiB로 확인했지만 실제 시험 직전 기록 여유를 다시 확인한다.
직접 launch는 bags/raw/follower를 기록하며, console 필터·원문 console.log·실행별 ROS 로그는
기존 run_course.sh 래퍼 기능이다. YOLO 임시 로그와 원본 CollisionData는 기본 bag만으로
영구 보존·충돌 검증된다고 가정하지 않는다.

## 근거와 이전 계획

- [10/22 동일 장면2회 결과·터널 재생](STABILITY_AUDIT_2026-10-22.md)
- [이전 수동 성공·미해결](CURRENT_STATUS_2026-10-22.md)
- [터널 정지와 재기동 실패 구분](CONSOLE_TUNNEL_RECHECK_2026-10-22.md)
- [원본 이름 변경·10/23 회귀 결과](REFERENCE_DIRECTORY_RENAME_2026-10-23.md)
- [대회 launch 변경·정적 검사](CTRL_START_LAUNCH_2026-10-23.md)
- [과거 자료 통합](ARCHIVE_CONSOLIDATION_2026-10-23.md)
- [원본·환경·전송의 한계](KNOWN_ISSUES.md)
- [10/23 갱신 전 계획 원문](history/DEVELOPMENT_WORKFLOW_before_2026-10-23.txt)
- [10/22 갱신 전 계획 원문](history/DEVELOPMENT_WORKFLOW_before_2026-10-22.txt)

이전 계획 원문의 상대 링크는 원래 DEVELOPMENT_WORKFLOW.md 위치를 기준으로 읽는다.
