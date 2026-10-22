# 개인 Codex 개발 계획과 인계

2026-10-22 현재 계획이다. [개발 규칙](../../AGENTS.md),
[현재 결과](CURRENT_STATUS_2026-10-22.md), [실행 안내](../README.md)를 따른다.
과거 팀 분업·미완료 체크박스를 현재 작업 체계로 승계하지 않는다.

## 현재 기준

- 원본 `2026foscar-competition/`은 비교 기준으로 보존한다.
- 최신 오른쪽 정적·보행자 수정본의 사용자 실제 주행에서 모든 CP·END·FINISH를 확인했다.
- 최신 시험의 공식 충돌/차선 채점·종료 후 Manual/P는 근거가 부족하다.
- 같은 날 직전 시험의 터널 s1828.09m AVOID 정지는 미해결이며 이번 성공으로 삭제하지 않는다.
- 생산 소스 회귀944 PASS, 도구13 PASS, 어댑터27 PASS, 격리 build/install 성공.
- 원본/리소스 해시·줄바꿈·식별자 기준 검사는 실패를 보존한다.

## 다음 작업

| 우선 | 목표 | 방법·완료 기준 |
| --- | --- | --- |
| P0 | 터널 정지 재현·원인 확정 | 새 raw.bag/인지/계획/제어를 같은 stamp로 비교. 진짜 장애물·지면 오탐·회피/지도/BEV 거부를 구분한 뒤 최소 수정 |
| P0 | 차선·충돌·인계 증거 | 정적 우회 바퀴 궤적·차선 경계·접촉 시간, CollisionData, 종료 후 실제0·Manual/P를 같은 시험에 기록 |
| P1 | 반복 안정성 | 동일 sample_scene 리셋·여러 신호 시점에서 무개입 전체 시험. 실패·미도달은 별도 기록 |
| P1 | 미션 변화 | 보행자 가림/재진입/동물, 회전교차로 간격, 고속도로 끼어들기/급제동, 터널 배치 변화 |
| P1 | 지연·손실·부하 | target/stamp/카메라 gate·재연결·pause/clock·executor 지연. threshold 우회 전 실패 경계 재현 |
| P2 | 배포·기록 경계 | 리소스 hash 검사·원본 CRLF·모델 README·bag 개행·YOLO 로그 영구 보존·종료 traceback 정합성 |

## 실행·검증 원칙

시작점 전용 수동 실행:

```bash
cd /home/foscar/RMT-ros1
bash ros1-port/docker/run_course.sh drive:=false bag:=true
# 위 실행 종료·확인 후 시뮬레이터 실제 주행
bash ros1-port/docker/run_course.sh drive:=true bag:=true
```

START 반경3m·동일 sample_scene·Manual/P·Status/제어/충돌 연결을 확인한다.
중간 위치에서 첫 랩 옵션을 쓰지 않는다. 직접 실행에는 자동 종료 감독이 없다.
상세 준비·정상 종료·비상 Pause·기록 위치는 [ROS1 README](../README.md)에 있다.

새 작업은 목표·영향 파일·구현·검증·완료 기준을 기록하고 목적별 브랜치에서
사용자 수정·미추적·삭제를 보존한다. 실험마다 새 출력 디렉터리를 사용하고
과거 JSON/SHA256/모델/경로/기대값을 바꿔 검사를 통과시키지 않는다.
주행 중 코드 변경 금지. 실제 차량은 별도 명시 승인 대상이다.
커밋 전 staged 파일·대용량/환경 제외·원본 보존·diff --check를 확인한다.
push/main 반영은 해당 작업의 명시적 지시에 따른다.

Windows 검사 명령과 Linux 실패/skip 범위는 AGENTS 및 기존 검증 절차를 따른다.
원본에서 테스트/캐시를 만들지 않고 격리 사본·새 verification/.work 결과를 사용한다.

## 근거 문서

- [최신 성공과 미검증](CURRENT_STATUS_2026-10-22.md)
- [오른쪽·보행자 재현](RIGHT_STATIC_PEDESTRIAN_2026-10-22.md)
- [터널 정지·출력 축소](CONSOLE_TUNNEL_RECHECK_2026-10-22.md)
- [앞선 감독 완주](FULL_COURSE_AUDIT_2026-10-22.md)
- [정리 근거](UNUSED_FILE_CLEANUP_2026-10-22.md) · [파일별 미션](FILE_MISSIONS_2026-10-22.md)
- [문서 분류](MARKDOWN_INDEX.md)
- [이전 계획 원문](history/DEVELOPMENT_WORKFLOW_before_2026-10-22.txt)

날짜별 과거 실험 문서는 수정하지 않는다. 이전 계획 원문의 상대 링크는
당시 DEVELOPMENT_WORKFLOW.md 위치를 기준으로 읽고 현재 우선순위와 구분한다.
