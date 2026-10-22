# RMT — ROS1 / MORAI 자율주행

2026 대학생 AI/SW 모빌리티 경진대회용 개인 개발 저장소다.
`2026foscar-competition/` 원본을 비교 기준으로 보존하고 `ros1-port/`에서
ROS1 Noetic·Python 3.10·catkin·MORAI 환경으로 개발한다.

## 현재 결과 — 2026-10-22

**오른쪽 정적 회피·보행자 수정본으로 START→모든 제공 CP→END→FINISH를
통과한 사용자 실제 주행 기록을 확인했다.** 공식 점수·차선 감점·무충돌 인증과는 구분한다.

| 항목 | 확인한 결과 | 남은 확인 |
| --- | --- | --- |
| 전체 코스 | 최신 bag에서 START, CP1~10·12~15, END 순서 통과 및 FINISH. CP11은 제공 파일에 없음 | 다른 시작 시점·배치·날씨에서 반복성 |
| 정적 장애물 | 오른쪽 요청 -3.5m, 실제 최대 우측 약3.27m, CP4 최소거리0.093m | 실제 바퀴의 차선 접촉·공식 감점 |
| 보행자 | 실제 PEDESTRIAN YIELD와 관측된 통과 후 완료 플래그 확인 | 다른 출현 시점·가림·동물·오분류 |
| 신호 | intersection_02 하단 도로 오검출 ROI 수정 후 통과 | 조명·안개·가림·다른 신호 위상 |
| 회전교차로 | 대기→진입→구간 통과 | 다른 차량 간격·우선권·최소거리 |
| 고속도로 | gap 대기→차선 변경→추종→복귀 | 끼어들기·급제동·오분류 |
| 터널 | 최신 시험 GPS→DR→GPS 및 구간 통과 | 직전 다른 시험의 s1828m AVOID 정지 원인은 미해결 |
| 종료 | bag의 FINISH와 거의0인 속도 확인 | 최신 수동 시험의 종료 후 Manual/P는 별도 근거 없음 |

최신 bag의 START→END 반경 진입 간격은 약176.56초다. 이는 후륜축 로컬
위치 기준이며 공식 주행시간이 아니다. 최신 수동 시험에는 원본 CollisionData
감독 기록이 없어 무충돌을 단정하지 않는다. 이전 왼쪽 회피 시험의 충돌0·
Manual/P 성공을 최신 오른쪽 시험의 증거로 합산하지 않는다.

[최신 성공·실패·미검증 정리](ros1-port/docs/CURRENT_STATUS_2026-10-22.md) ·
[최신 bag 검증 요약](ros1-port/docs/verification-20261022/manual-course-summary.json) ·
[작업 계획](ros1-port/docs/DEVELOPMENT_WORKFLOW.md)

## 실행

Ubuntu MORAI PC의 현재 경로는 `/home/foscar/RMT-ros1`이다.
환경 구축은 [ROS1 실행 안내](ros1-port/README.md),
[Docker 안내](ros1-port/docker/README.md)를 따른다.

1. MORAI에서 같은 sample_scene을 로드하고 원래 시작점·Manual/P로 둔다.
2. Status `127.0.0.1:9088 → 127.0.0.1:909`, Ego Ctrl `9093`, Collision 목적지 `9092`를 Connect한다.
3. 기존 launch를 정상 종료한 상태에서 수신 전용으로 확인한다.

```bash
cd /home/foscar/RMT-ros1
bash ros1-port/docker/run_course.sh drive:=false bag:=true
```

위 실행을 Ctrl+C로 종료한 뒤 실제 시뮬레이터 주행:

```bash
bash ros1-port/docker/run_course.sh drive:=true bag:=true
```

실행 직후 출발할 수 있다. 같은 터미널에서 Ctrl+C 한 번 후 실제 속도0과
`shutdown handoff confirmed: Manual/P, brake released`를 확인한다.
비상 시 MORAI Pause를 사용하되 Pause만으로 정지·인계 성공을 판정하지 않는다.
직접 실행 래퍼에는 충돌·장기 무진행 자동 종료 감독이 없다.
새 `docker/artifacts/manual-*`에 원문 console·ROS·follower CSV·bag·원본 센서를 남긴다.
출력만 축소하며 제어 정책을 우회하지 않는다.

**정확히 한 점에 놓을 필요는 없다.** 이 실행은 폐루프의 START 반경3m 안에서
첫 랩 s0으로 초기화한다. 반경 밖·중간 위치에서는 FAULT로 거부한다.
이는 시작/끝이 겹치는 폐루프에서 마지막 구간으로 잘못 투영되는 것을 막는
명시적 첫 랩 옵션이며 허용 반경을 임의로 넓히지 않는다.
중간 위치 수신 점검은 `docker/local.launch drive:=false`로 별도 수행한다.

## 알고리즘

| 구성·미션 | 현재 방식 |
| --- | --- |
| 추종·속도 | Pure Pursuit, 가변 lookahead·횡오차 적분·조향 필터; PI 기반 속도 제어와 감속 feed-forward |
| 위치 | GPS/IMU/차속, GPS 음영 DR, 복귀 blending |
| 신호 | YOLO ONNX/CUDA → 교차로 ROI → 프레임 확인 → 신호 기억·정지선 제동 |
| LiDAR | 지면 평면 후보 추정·최소제곱 보정 → DBSCAN → 추적·규칙 분류 |
| 정적 | 제공 상자/경로 사전정보 기반 오른쪽 5차 곡선, 지도·실시간 BEV 검사 |
| 보행자 | LiDAR 형태·이력 분류, 횡단 예측, YIELD 및 관측된 이탈 확인 |
| 회전교차로 | 원형 차로 점유 구간·경계 Kalman 추정·예측 빈틈 진입 |
| 고속도로 | 차로 점유·시간 슬롯 탐색·차간거리 제어·5차 차선 변경/복귀 |
| 터널 | 재질/지면 지지 검사·BEV·좌우 통과 조합·5차 곡선·DR |

카메라 슬라이딩 윈도우 차선 검출을 쓰는 구조가 아니다. 일반 회피에는
횡방향 후보 비용 탐색이 있으나 현재 정적 통과를 일반 래티스의 성공으로
표현하지 않는다. 고정 배치 사전정보와 실제 센서 제동을 함께 사용한다.

## 검증과 남은 작업

현재 오른쪽/보행자 production 소스의 알고리즘 회귀 **944 PASS**, 도구13 PASS,
ROS1 어댑터27 PASS, native 메시지/TF·격리 catkin build/install·노드 import 통과.
리소스 해시/원본 식별자 기준/메시지 줄바꿈 관련 검사는 실패 상태를 보존했다.
[검사 요약](ros1-port/docs/verification-20261022/checks-summary.json)을 참고한다.
Windows 과거 결과는 현재 Linux 실행과 구분한다.

다음 우선순위는 터널 s1828 반복 정지 원인 재현, 차선·공식 감점 확인,
다양한 보행자/차량 조건과 전체 코스 반복성, 입력 지연·손실·재연결·과부하,
배포 해시 검사 정합성이다. 완주1회를 모든 조건의 성공으로 해석하지 않는다.

## 문서와 보존

- [개발 규칙](AGENTS.md) · [문서 분류](ros1-port/docs/MARKDOWN_INDEX.md)
- [오른쪽 정적·보행자 수정](ros1-port/docs/RIGHT_STATIC_PEDESTRIAN_2026-10-22.md)
- [앞선 감독 주행 기록](ros1-port/docs/FULL_COURSE_AUDIT_2026-10-22.md)
- [터널 정지·출력 축소](ros1-port/docs/CONSOLE_TUNNEL_RECHECK_2026-10-22.md)
- [미사용 정리 근거](ros1-port/docs/UNUSED_FILE_CLEANUP_2026-10-22.md) · [파일별 미션](ros1-port/docs/FILE_MISSIONS_2026-10-22.md)
- [과거 루트 안내 원문](ros1-port/docs/history/ROOT_README_before_2026-10-22.txt)

원본·각 파일의 작성자/출처/저작권/라이선스를 보존한다. ROS1 이식 기준은
`a1ea82efbf8d5f165201b7f51bf8a141439fb8c7`이며 이후 허용된 기능 수정은
원본 동등성 검사와 구분해 기록한다. 원본의 Apache-2.0 및 어댑터의
Apache-2.0/BSD-3-Clause 등 패키지별 선언은 각 package.xml/소스가 기준이다.

bag·영상·build/devel/install·Docker 이미지·대용량 artifacts는 Git에 올리지 않는다.
날짜별 실험 기록과 검증 JSON/SHA256은 과거 근거로 보존한다.
GitHub push와 main 병합은 작업마다 사용자의 명시적 지시에 따른다.
