# Markdown 분류와 사용 기준

## 2026-10-22 현재 안내

- [최신 실제 성공·미해결·미검증](CURRENT_STATUS_2026-10-22.md)
- [현재 개발 계획](DEVELOPMENT_WORKFLOW.md)
- [루트 README](../../README.md) · [ROS1 실행](../README.md) · [Docker 환경](../docker/README.md)
- [최신 수동 bag 요약](verification-20261022/manual-course-summary.json)
- [알고리즘/native 검사 요약](verification-20261022/checks-summary.json)
- [오른쪽 정적·보행자 수정](RIGHT_STATIC_PEDESTRIAN_2026-10-22.md)
- [터널 정지·터미널 출력](CONSOLE_TUNNEL_RECHECK_2026-10-22.md)
- [이전 감독 시험](FULL_COURSE_AUDIT_2026-10-22.md)
- [파일별 미션](FILE_MISSIONS_2026-10-22.md) · [미사용 정리](UNUSED_FILE_CLEANUP_2026-10-22.md)

현재 README·계획의 이전 원문은 history/*.txt로 보존했다. 해당 원문의
상대 경로는 원래 파일 위치 문맥으로 읽는다. 아래 10/13 분류·파일 수·검사
수치는 당시 결과이며 새 문서 추가 후 현재 합계를 뜻하지 않는다.


2026-10-13 저장소의 Markdown 경로와 본문/제목을 조사한 목록이다. Git 추적 문서와 이번 신규 문서를 포함하며,
ignored 환경·build·artifact 사본은 제외한다. 경로별 분류는 용도를 뜻하며 과거 원문의 이력·작성자·역할·출처를 고치지 않는다.

- 현재 작업은 AGENTS와 DEVELOPMENT_WORKFLOW를 기준으로 목표·영향 파일·구현·검증·완료 기준을 작성한다.
- `개발계획서.md`, `남은 할일.md`, `할일.md`와 예전 팀 분업/백로그는 과거 자료다. 체크되지 않은 항목을 현재 미완료로 자동 승계하지 않는다.
- 원본 및 이식본에 복사된 기술 문서에는 ROS2 명령, 예전 경로·포트·완료 상태가 있다. ROS1 현재 실행 안내와 실제 코드/JSON/YAML을 먼저 확인한다.
- 날짜별 검증 문서·기존 JSON·SHA256 manifest는 당시 결과의 근거다. 새 실험은 별도 결과 경로와 새 기록으로 남긴다.
- 기존 사양/외부 자료는 출처 및 버전이 있는 참고 자료다. 현재 구현 완료 여부의 근거와 구분한다.
- 과거 자료의 깨진 링크나 현 PC에 없는 경로도 이력의 일부다. 이번에는 현재 안내의 링크를 검증하고 원문은 보존한다.

현재 수정·신규 문서6개의 내부 링크240개와 주요 명령/리소스 경로12개를 정적으로 확인했다.
나머지 보존 문서의 내부 링크232개에서는 기존 경로 불일치19개를 발견했다. 아래 원문은 수정하지 않았다.
검사 artifact는 `verification/.work/markdown-refactor-check.json`에 남긴다. ROS·Bash 실행 성공이나 외부 URL 접속 확인을 의미하지 않는다.

| 보존 문서 범위 | 없는 링크 대상 | 건수 |
| --- | --- | ---: |
| `2026foscar`, `2026foscar-competition`, `2026foscar-records`, `2026foscar-team2`의 `src/foscar_lidar/README.md` | `../../ROUNDABOUT.md` | 4 |
| 위4개 폴더의 `src/foscar_planning/README.md` | `../../ROUNDABOUT.md`, `../../docs/HIGHWAY.md` | 8 |
| `2026foscar-team2/src/foscar_camera_train/개발구조.md` | `foscar_camera_train/palette.py` | 1 |
| `ros1-port/src/foscar_camera_train/`의 개발구조·개발명세서·사용법 | `../../YOLO_다른PC_인수인계.md` | 3 |
| `ros1-port/src/foscar_lidar/README.md` | `../../ROUNDABOUT.md` | 1 |
| `ros1-port/src/foscar_planning/README.md` | `../../ROUNDABOUT.md`, `../../docs/HIGHWAY.md` | 2 |

| 분류 | 파일 수 |
| --- | ---: |
| 현재 개인 개발 문서 | 6 |
| 현재 ROS1 기술 참고·검증 절차 | 7 |
| 과거 ROS1 검증·실행 근거 | 6 |
| 이식본에 보존된 원본 기술·개발 문서 | 12 |
| 비교 기준 원본 문서 | 32 |
| 과거 팀 개발·실험·인계 자료 | 81 |
| 기존 사양·외부 코드 참고 자료 | 10 |
| 합계 | 154 |

## 현재 개인 개발 문서

- [AGENTS.md](../../AGENTS.md)
- [README.md](../../README.md)
- [ros1-port/README.md](../../ros1-port/README.md)
- [ros1-port/docs/DEVELOPMENT_WORKFLOW.md](../../ros1-port/docs/DEVELOPMENT_WORKFLOW.md)
- [ros1-port/docs/IDENTIFIERS_DOCS_2026-10-13.md](../../ros1-port/docs/IDENTIFIERS_DOCS_2026-10-13.md)
- [ros1-port/docs/MARKDOWN_INDEX.md](../../ros1-port/docs/MARKDOWN_INDEX.md)

## 현재 ROS1 기술 참고·검증 절차

- [ros1-port/docker/README.md](../../ros1-port/docker/README.md)
- [ros1-port/docs/CHANGES.md](../../ros1-port/docs/CHANGES.md)
- [ros1-port/docs/KNOWN_ISSUES.md](../../ros1-port/docs/KNOWN_ISSUES.md)
- [ros1-port/docs/MESSAGE_DEFAULTS.md](../../ros1-port/docs/MESSAGE_DEFAULTS.md)
- [ros1-port/docs/NOETIC_ENVIRONMENT.md](../../ros1-port/docs/NOETIC_ENVIRONMENT.md)
- [ros1-port/docs/ROS1_INTEGRATION.md](../../ros1-port/docs/ROS1_INTEGRATION.md)
- [ros1-port/src/foscar_ros1/README.md](../../ros1-port/src/foscar_ros1/README.md)

## 과거 ROS1 검증·실행 근거

- [ros1-port/docs/MORAI_MANUAL_LAUNCH_2026-10-13.md](../../ros1-port/docs/MORAI_MANUAL_LAUNCH_2026-10-13.md)
- [ros1-port/docs/MORAI_SHORT_DRIVE_2026-10-13.md](../../ros1-port/docs/MORAI_SHORT_DRIVE_2026-10-13.md)
- [ros1-port/docs/MORAI_STATUS_FOLLOWUP_2026-10-13.md](../../ros1-port/docs/MORAI_STATUS_FOLLOWUP_2026-10-13.md)
- [ros1-port/docs/NOETIC_DOCKER_VALIDATION.md](../../ros1-port/docs/NOETIC_DOCKER_VALIDATION.md)
- [ros1-port/docs/WORK_LOG_2026-10-13.md](../../ros1-port/docs/WORK_LOG_2026-10-13.md)
- [ros1-port/docs/verification.md](../../ros1-port/docs/verification.md)

## 이식본에 보존된 원본 기술·개발 문서

- [ros1-port/src/foscar_camera/README.md](../../ros1-port/src/foscar_camera/README.md)
- [ros1-port/src/foscar_camera/YOLO_STOPLINE_2026-09-28.md](../../ros1-port/src/foscar_camera/YOLO_STOPLINE_2026-09-28.md)
- [ros1-port/src/foscar_camera/models/README.md](../../ros1-port/src/foscar_camera/models/README.md)
- [ros1-port/src/foscar_camera_train/개발구조.md](../../ros1-port/src/foscar_camera_train/%EA%B0%9C%EB%B0%9C%EA%B5%AC%EC%A1%B0.md)
- [ros1-port/src/foscar_camera_train/개발명세서.md](../../ros1-port/src/foscar_camera_train/%EA%B0%9C%EB%B0%9C%EB%AA%85%EC%84%B8%EC%84%9C.md)
- [ros1-port/src/foscar_camera_train/사용법.md](../../ros1-port/src/foscar_camera_train/%EC%82%AC%EC%9A%A9%EB%B2%95.md)
- [ros1-port/src/foscar_lidar/README.md](../../ros1-port/src/foscar_lidar/README.md)
- [ros1-port/src/foscar_lidar/test/data/README.md](../../ros1-port/src/foscar_lidar/test/data/README.md)
- [ros1-port/src/foscar_lidar/오탐분석.md](../../ros1-port/src/foscar_lidar/%EC%98%A4%ED%83%90%EB%B6%84%EC%84%9D.md)
- [ros1-port/src/foscar_planning/HIGHWAY.md](../../ros1-port/src/foscar_planning/HIGHWAY.md)
- [ros1-port/src/foscar_planning/README.md](../../ros1-port/src/foscar_planning/README.md)
- [ros1-port/src/foscar_planning/ROUNDABOUT.md](../../ros1-port/src/foscar_planning/ROUNDABOUT.md)

## 비교 기준 원본 문서

- [2026foscar-competition/CLAUDE.md](../../2026foscar-competition/CLAUDE.md)
- [2026foscar-competition/HANDOFF_AVOID.md](../../2026foscar-competition/HANDOFF_AVOID.md)
- [2026foscar-competition/README.md](../../2026foscar-competition/README.md)
- [2026foscar-competition/YOLO_다른PC_인수인계.md](../../2026foscar-competition/YOLO_%EB%8B%A4%EB%A5%B8PC_%EC%9D%B8%EC%88%98%EC%9D%B8%EA%B3%84.md)
- [2026foscar-competition/docs/superpowers/plans/2026-10-06-bev-avoidance.md](../../2026foscar-competition/docs/superpowers/plans/2026-10-06-bev-avoidance.md)
- [2026foscar-competition/docs/superpowers/plans/2026-10-06-obstacle-path-validation.md](../../2026foscar-competition/docs/superpowers/plans/2026-10-06-obstacle-path-validation.md)
- [2026foscar-competition/docs/superpowers/specs/2026-10-06-bev-avoidance-design.md](../../2026foscar-competition/docs/superpowers/specs/2026-10-06-bev-avoidance-design.md)
- [2026foscar-competition/practice/HANDOFF.md](../../2026foscar-competition/practice/HANDOFF.md)
- [2026foscar-competition/practice/HIGHWAY_PIPELINE.md](../../2026foscar-competition/practice/HIGHWAY_PIPELINE.md)
- [2026foscar-competition/practice/README.md](../../2026foscar-competition/practice/README.md)
- [2026foscar-competition/practice/TuningPoint.md](../../2026foscar-competition/practice/TuningPoint.md)
- [2026foscar-competition/practice/sim/obstacle_paths/BEV_CLEARANCE.md](../../2026foscar-competition/practice/sim/obstacle_paths/BEV_CLEARANCE.md)
- [2026foscar-competition/practice/sim/ordinary_tuning/RESULTS.md](../../2026foscar-competition/practice/sim/ordinary_tuning/RESULTS.md)
- [2026foscar-competition/practice/sim/ordinary_tuning/highway_review.md](../../2026foscar-competition/practice/sim/ordinary_tuning/highway_review.md)
- [2026foscar-competition/practice/sim/ordinary_tuning/plan.md](../../2026foscar-competition/practice/sim/ordinary_tuning/plan.md)
- [2026foscar-competition/practice/sim/tunnel_tuning/plan.md](../../2026foscar-competition/practice/sim/tunnel_tuning/plan.md)
- [2026foscar-competition/practice/sim/tunnel_tuning/results.md](../../2026foscar-competition/practice/sim/tunnel_tuning/results.md)
- [2026foscar-competition/practice/일어나면_먼저_볼것.md](../../2026foscar-competition/practice/%EC%9D%BC%EC%96%B4%EB%82%98%EB%A9%B4_%EB%A8%BC%EC%A0%80_%EB%B3%BC%EA%B2%83.md)
- [2026foscar-competition/src/foscar_camera/README.md](../../2026foscar-competition/src/foscar_camera/README.md)
- [2026foscar-competition/src/foscar_camera/YOLO_STOPLINE_2026-09-28.md](../../2026foscar-competition/src/foscar_camera/YOLO_STOPLINE_2026-09-28.md)
- [2026foscar-competition/src/foscar_camera/models/README.md](../../2026foscar-competition/src/foscar_camera/models/README.md)
- [2026foscar-competition/src/foscar_camera_train/개발구조.md](../../2026foscar-competition/src/foscar_camera_train/%EA%B0%9C%EB%B0%9C%EA%B5%AC%EC%A1%B0.md)
- [2026foscar-competition/src/foscar_camera_train/개발명세서.md](../../2026foscar-competition/src/foscar_camera_train/%EA%B0%9C%EB%B0%9C%EB%AA%85%EC%84%B8%EC%84%9C.md)
- [2026foscar-competition/src/foscar_camera_train/사용법.md](../../2026foscar-competition/src/foscar_camera_train/%EC%82%AC%EC%9A%A9%EB%B2%95.md)
- [2026foscar-competition/src/foscar_lidar/README.md](../../2026foscar-competition/src/foscar_lidar/README.md)
- [2026foscar-competition/src/foscar_lidar/test/data/README.md](../../2026foscar-competition/src/foscar_lidar/test/data/README.md)
- [2026foscar-competition/src/foscar_lidar/오탐분석.md](../../2026foscar-competition/src/foscar_lidar/%EC%98%A4%ED%83%90%EB%B6%84%EC%84%9D.md)
- [2026foscar-competition/src/foscar_planning/HIGHWAY.md](../../2026foscar-competition/src/foscar_planning/HIGHWAY.md)
- [2026foscar-competition/src/foscar_planning/README.md](../../2026foscar-competition/src/foscar_planning/README.md)
- [2026foscar-competition/src/foscar_planning/ROUNDABOUT.md](../../2026foscar-competition/src/foscar_planning/ROUNDABOUT.md)
- [2026foscar-competition/tools/lidar_lane/README.md](../../2026foscar-competition/tools/lidar_lane/README.md)
- [2026foscar-competition/tools/위치기록_사용법.md](../../2026foscar-competition/tools/%EC%9C%84%EC%B9%98%EA%B8%B0%EB%A1%9D_%EC%82%AC%EC%9A%A9%EB%B2%95.md)

## 과거 팀 개발·실험·인계 자료

- [2026foscar-records/CLAUDE.md](../../2026foscar-records/CLAUDE.md)
- [2026foscar-records/HANDOFF_AVOID.md](../../2026foscar-records/HANDOFF_AVOID.md)
- [2026foscar-records/README.md](../../2026foscar-records/README.md)
- [2026foscar-records/YOLO_다른PC_인수인계.md](../../2026foscar-records/YOLO_%EB%8B%A4%EB%A5%B8PC_%EC%9D%B8%EC%88%98%EC%9D%B8%EA%B3%84.md)
- [2026foscar-records/docs/superpowers/plans/2026-10-06-bev-avoidance.md](../../2026foscar-records/docs/superpowers/plans/2026-10-06-bev-avoidance.md)
- [2026foscar-records/docs/superpowers/plans/2026-10-06-obstacle-path-validation.md](../../2026foscar-records/docs/superpowers/plans/2026-10-06-obstacle-path-validation.md)
- [2026foscar-records/docs/superpowers/specs/2026-10-06-bev-avoidance-design.md](../../2026foscar-records/docs/superpowers/specs/2026-10-06-bev-avoidance-design.md)
- [2026foscar-records/practice/HANDOFF.md](../../2026foscar-records/practice/HANDOFF.md)
- [2026foscar-records/practice/HIGHWAY_PIPELINE.md](../../2026foscar-records/practice/HIGHWAY_PIPELINE.md)
- [2026foscar-records/practice/README.md](../../2026foscar-records/practice/README.md)
- [2026foscar-records/practice/TuningPoint.md](../../2026foscar-records/practice/TuningPoint.md)
- [2026foscar-records/practice/sim/obstacle_paths/BEV_CLEARANCE.md](../../2026foscar-records/practice/sim/obstacle_paths/BEV_CLEARANCE.md)
- [2026foscar-records/practice/sim/ordinary_tuning/RESULTS.md](../../2026foscar-records/practice/sim/ordinary_tuning/RESULTS.md)
- [2026foscar-records/practice/일어나면_먼저_볼것.md](../../2026foscar-records/practice/%EC%9D%BC%EC%96%B4%EB%82%98%EB%A9%B4_%EB%A8%BC%EC%A0%80_%EB%B3%BC%EA%B2%83.md)
- [2026foscar-records/src/foscar_camera/README.md](../../2026foscar-records/src/foscar_camera/README.md)
- [2026foscar-records/src/foscar_camera/YOLO_STOPLINE_2026-09-28.md](../../2026foscar-records/src/foscar_camera/YOLO_STOPLINE_2026-09-28.md)
- [2026foscar-records/src/foscar_camera/models/README.md](../../2026foscar-records/src/foscar_camera/models/README.md)
- [2026foscar-records/src/foscar_camera_train/개발구조.md](../../2026foscar-records/src/foscar_camera_train/%EA%B0%9C%EB%B0%9C%EA%B5%AC%EC%A1%B0.md)
- [2026foscar-records/src/foscar_camera_train/개발명세서.md](../../2026foscar-records/src/foscar_camera_train/%EA%B0%9C%EB%B0%9C%EB%AA%85%EC%84%B8%EC%84%9C.md)
- [2026foscar-records/src/foscar_camera_train/사용법.md](../../2026foscar-records/src/foscar_camera_train/%EC%82%AC%EC%9A%A9%EB%B2%95.md)
- [2026foscar-records/src/foscar_lidar/README.md](../../2026foscar-records/src/foscar_lidar/README.md)
- [2026foscar-records/src/foscar_lidar/test/data/README.md](../../2026foscar-records/src/foscar_lidar/test/data/README.md)
- [2026foscar-records/src/foscar_lidar/오탐분석.md](../../2026foscar-records/src/foscar_lidar/%EC%98%A4%ED%83%90%EB%B6%84%EC%84%9D.md)
- [2026foscar-records/src/foscar_planning/HIGHWAY.md](../../2026foscar-records/src/foscar_planning/HIGHWAY.md)
- [2026foscar-records/src/foscar_planning/README.md](../../2026foscar-records/src/foscar_planning/README.md)
- [2026foscar-records/src/foscar_planning/ROUNDABOUT.md](../../2026foscar-records/src/foscar_planning/ROUNDABOUT.md)
- [2026foscar-records/tools/lidar_lane/README.md](../../2026foscar-records/tools/lidar_lane/README.md)
- [2026foscar-records/tools/위치기록_사용법.md](../../2026foscar-records/tools/%EC%9C%84%EC%B9%98%EA%B8%B0%EB%A1%9D_%EC%82%AC%EC%9A%A9%EB%B2%95.md)
- [2026foscar-team2/CLAUDE.md](../../2026foscar-team2/CLAUDE.md)
- [2026foscar-team2/HANDOFF_AVOID.md](../../2026foscar-team2/HANDOFF_AVOID.md)
- [2026foscar-team2/README.md](../../2026foscar-team2/README.md)
- [2026foscar-team2/YOLO_다른PC_인수인계.md](../../2026foscar-team2/YOLO_%EB%8B%A4%EB%A5%B8PC_%EC%9D%B8%EC%88%98%EC%9D%B8%EA%B3%84.md)
- [2026foscar-team2/docs/superpowers/plans/2026-10-01-highway-overtake-phase1.md](../../2026foscar-team2/docs/superpowers/plans/2026-10-01-highway-overtake-phase1.md)
- [2026foscar-team2/docs/superpowers/plans/2026-10-01-highway-overtake-phase2-a1.md](../../2026foscar-team2/docs/superpowers/plans/2026-10-01-highway-overtake-phase2-a1.md)
- [2026foscar-team2/docs/superpowers/specs/2026-10-01-highway-overtake-design.md](../../2026foscar-team2/docs/superpowers/specs/2026-10-01-highway-overtake-design.md)
- [2026foscar-team2/practice/HANDOFF.md](../../2026foscar-team2/practice/HANDOFF.md)
- [2026foscar-team2/practice/README.md](../../2026foscar-team2/practice/README.md)
- [2026foscar-team2/practice/TuningPoint.md](../../2026foscar-team2/practice/TuningPoint.md)
- [2026foscar-team2/practice/일어나면_먼저_볼것.md](../../2026foscar-team2/practice/%EC%9D%BC%EC%96%B4%EB%82%98%EB%A9%B4_%EB%A8%BC%EC%A0%80_%EB%B3%BC%EA%B2%83.md)
- [2026foscar-team2/src/foscar_camera/README.md](../../2026foscar-team2/src/foscar_camera/README.md)
- [2026foscar-team2/src/foscar_camera/YOLO_STOPLINE_2026-09-28.md](../../2026foscar-team2/src/foscar_camera/YOLO_STOPLINE_2026-09-28.md)
- [2026foscar-team2/src/foscar_camera/models/README.md](../../2026foscar-team2/src/foscar_camera/models/README.md)
- [2026foscar-team2/src/foscar_camera_train/개발구조.md](../../2026foscar-team2/src/foscar_camera_train/%EA%B0%9C%EB%B0%9C%EA%B5%AC%EC%A1%B0.md)
- [2026foscar-team2/src/foscar_camera_train/개발명세서.md](../../2026foscar-team2/src/foscar_camera_train/%EA%B0%9C%EB%B0%9C%EB%AA%85%EC%84%B8%EC%84%9C.md)
- [2026foscar-team2/src/foscar_camera_train/사용법.md](../../2026foscar-team2/src/foscar_camera_train/%EC%82%AC%EC%9A%A9%EB%B2%95.md)
- [2026foscar-team2/src/foscar_lidar/README.md](../../2026foscar-team2/src/foscar_lidar/README.md)
- [2026foscar-team2/src/foscar_lidar/test/data/README.md](../../2026foscar-team2/src/foscar_lidar/test/data/README.md)
- [2026foscar-team2/src/foscar_lidar/오탐분석.md](../../2026foscar-team2/src/foscar_lidar/%EC%98%A4%ED%83%90%EB%B6%84%EC%84%9D.md)
- [2026foscar-team2/src/foscar_planning/HIGHWAY.md](../../2026foscar-team2/src/foscar_planning/HIGHWAY.md)
- [2026foscar-team2/src/foscar_planning/README.md](../../2026foscar-team2/src/foscar_planning/README.md)
- [2026foscar-team2/src/foscar_planning/ROUNDABOUT.md](../../2026foscar-team2/src/foscar_planning/ROUNDABOUT.md)
- [2026foscar-team2/tools/lidar_lane/README.md](../../2026foscar-team2/tools/lidar_lane/README.md)
- [2026foscar-team2/tools/위치기록_사용법.md](../../2026foscar-team2/tools/%EC%9C%84%EC%B9%98%EA%B8%B0%EB%A1%9D_%EC%82%AC%EC%9A%A9%EB%B2%95.md)
- [2026foscar/CLAUDE.md](../../2026foscar/CLAUDE.md)
- [2026foscar/HANDOFF_AVOID.md](../../2026foscar/HANDOFF_AVOID.md)
- [2026foscar/README.md](../../2026foscar/README.md)
- [2026foscar/YOLO_다른PC_인수인계.md](../../2026foscar/YOLO_%EB%8B%A4%EB%A5%B8PC_%EC%9D%B8%EC%88%98%EC%9D%B8%EA%B3%84.md)
- [2026foscar/practice/HANDOFF.md](../../2026foscar/practice/HANDOFF.md)
- [2026foscar/practice/README.md](../../2026foscar/practice/README.md)
- [2026foscar/practice/TuningPoint.md](../../2026foscar/practice/TuningPoint.md)
- [2026foscar/practice/일어나면_먼저_볼것.md](../../2026foscar/practice/%EC%9D%BC%EC%96%B4%EB%82%98%EB%A9%B4_%EB%A8%BC%EC%A0%80_%EB%B3%BC%EA%B2%83.md)
- [2026foscar/practice/터널_보행자_변경내역.md](../../2026foscar/practice/%ED%84%B0%EB%84%90_%EB%B3%B4%ED%96%89%EC%9E%90_%EB%B3%80%EA%B2%BD%EB%82%B4%EC%97%AD.md)
- [2026foscar/src/foscar_camera/README.md](../../2026foscar/src/foscar_camera/README.md)
- [2026foscar/src/foscar_camera/YOLO_STOPLINE_2026-09-28.md](../../2026foscar/src/foscar_camera/YOLO_STOPLINE_2026-09-28.md)
- [2026foscar/src/foscar_camera/models/README.md](../../2026foscar/src/foscar_camera/models/README.md)
- [2026foscar/src/foscar_camera_train/개발구조.md](../../2026foscar/src/foscar_camera_train/%EA%B0%9C%EB%B0%9C%EA%B5%AC%EC%A1%B0.md)
- [2026foscar/src/foscar_camera_train/개발명세서.md](../../2026foscar/src/foscar_camera_train/%EA%B0%9C%EB%B0%9C%EB%AA%85%EC%84%B8%EC%84%9C.md)
- [2026foscar/src/foscar_camera_train/사용법.md](../../2026foscar/src/foscar_camera_train/%EC%82%AC%EC%9A%A9%EB%B2%95.md)
- [2026foscar/src/foscar_lidar/README.md](../../2026foscar/src/foscar_lidar/README.md)
- [2026foscar/src/foscar_lidar/test/data/README.md](../../2026foscar/src/foscar_lidar/test/data/README.md)
- [2026foscar/src/foscar_lidar/오탐분석.md](../../2026foscar/src/foscar_lidar/%EC%98%A4%ED%83%90%EB%B6%84%EC%84%9D.md)
- [2026foscar/src/foscar_planning/HIGHWAY.md](../../2026foscar/src/foscar_planning/HIGHWAY.md)
- [2026foscar/src/foscar_planning/README.md](../../2026foscar/src/foscar_planning/README.md)
- [2026foscar/src/foscar_planning/ROUNDABOUT.md](../../2026foscar/src/foscar_planning/ROUNDABOUT.md)
- [2026foscar/tools/lidar_lane/README.md](../../2026foscar/tools/lidar_lane/README.md)
- [2026foscar/tools/위치기록_사용법.md](../../2026foscar/tools/%EC%9C%84%EC%B9%98%EA%B8%B0%EB%A1%9D_%EC%82%AC%EC%9A%A9%EB%B2%95.md)
- [HANDOFF_터널_2026-10-12.md](../../HANDOFF_%ED%84%B0%EB%84%90_2026-10-12.md)
- [개발계획서.md](../../%EA%B0%9C%EB%B0%9C%EA%B3%84%ED%9A%8D%EC%84%9C.md)
- [남은 할일.md](../../%EB%82%A8%EC%9D%80%20%ED%95%A0%EC%9D%BC.md)
- [측정테스트파일/LOW_SPEED_README.md](../../%EC%B8%A1%EC%A0%95%ED%85%8C%EC%8A%A4%ED%8A%B8%ED%8C%8C%EC%9D%BC/LOW_SPEED_README.md)
- [할일.md](../../%ED%95%A0%EC%9D%BC.md)

## 기존 사양·외부 코드 참고 자료

- [Readme, 각종정보파일/DEVELOPMENT_PLAN.md](../../Readme%2C%20%EA%B0%81%EC%A2%85%EC%A0%95%EB%B3%B4%ED%8C%8C%EC%9D%BC/DEVELOPMENT_PLAN.md)
- [Readme, 각종정보파일/MORAI-NetworkModule/README.md](../../Readme%2C%20%EA%B0%81%EC%A2%85%EC%A0%95%EB%B3%B4%ED%8C%8C%EC%9D%BC/MORAI-NetworkModule/README.md)
- [Readme, 각종정보파일/PROJECT_MASTER.md](../../Readme%2C%20%EA%B0%81%EC%A2%85%EC%A0%95%EB%B3%B4%ED%8C%8C%EC%9D%BC/PROJECT_MASTER.md)
- [sim_2025/Simulator_2025-ai_mission/README.md](../../sim_2025/Simulator_2025-ai_mission/README.md)
- [sim_2025/Simulator_2025-ai_mission/src/MORAI-ROS_morai_msgs/README.md](../../sim_2025/Simulator_2025-ai_mission/src/MORAI-ROS_morai_msgs/README.md)
- [sim_2025/Simulator_2025-ai_mission/src/MORAI_UDP_NetworkModule/README.md](../../sim_2025/Simulator_2025-ai_mission/src/MORAI_UDP_NetworkModule/README.md)
- [sim_2025/Simulator_2025-main/Simulator_2025-main/README.md](../../sim_2025/Simulator_2025-main/Simulator_2025-main/README.md)
- [sim_2025/Simulator_2025-main/Simulator_2025-main/src/MORAI-ROS_morai_msgs/README.md](../../sim_2025/Simulator_2025-main/Simulator_2025-main/src/MORAI-ROS_morai_msgs/README.md)
- [sim_2025/Simulator_2025-main/Simulator_2025-main/src/MORAI_UDP_NetworkModule/README.md](../../sim_2025/Simulator_2025-main/Simulator_2025-main/src/MORAI_UDP_NetworkModule/README.md)
- [규정집_v1.1.5_예비_대학생AISW모빌리티 경진대회.md](../../%EA%B7%9C%EC%A0%95%EC%A7%91_v1.1.5_%EC%98%88%EB%B9%84_%EB%8C%80%ED%95%99%EC%83%9DAISW%EB%AA%A8%EB%B9%8C%EB%A6%AC%ED%8B%B0%20%EA%B2%BD%EC%A7%84%EB%8C%80%ED%9A%8C.md)
