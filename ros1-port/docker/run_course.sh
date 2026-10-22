#!/usr/bin/env bash
# Same first-lap launch, concise terminal, persistent raw/ROS/follower logs.
# No arguments means drive=false. Explicitly pass drive:=true to drive MORAI.
set -euo pipefail
here=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
mkdir -p "$here/artifacts"
run_output=$(mktemp -d "$here/artifacts/manual-$(date +%Y%m%d-%H%M%S)-XXXXXX")
chmod g+rwx "$run_output"
mounted_output="/workspace/ros1-port/docker/artifacts/$(basename "$run_output")"
cat > "$run_output/manual.launch" <<EOF
<launch>
  <arg name="drive" default="false" />
  <arg name="bag" default="true" />
  <arg name="raw" default="true" />
  <include file="/workspace/ros1-port/docker/local.launch">
    <arg name="drive" value="\$(arg drive)" />
    <arg name="bag" value="\$(arg bag)" />
    <arg name="bag_dir" value="$mounted_output/bags" />
  </include>
  <group if="\$(arg bag)">
    <node pkg="rosbag" type="record" name="manual_sensor_bag" output="log"
          if="\$(arg raw)"
          args="-O $mounted_output/raw.bag /sensors/gps /sensors/imu /sensors/lidar/points /sensors/camera/traffic/compressed /perception/traffic_light/debug/compressed /tf /tf_static /rosout_agg" />
  </group>
  <param name="/localization/start_at_beginning" value="true" type="bool" />
  <param name="/path_follower/start_at_beginning" value="true" type="bool" />
  <param name="/behavior_node/start_at_beginning" value="true" type="bool" />
  <param name="/path_follower/log_dir" value="$mounted_output/follower" type="str" />
</launch>
EOF
printf '기록 폴더: %s\n화면 반복 출력만 줄입니다. 종료: Ctrl+C 한 번, Manual/P 인계 확인.\n' "$run_output"
bash "$here/run.sh" --receive-root \
  env ROS_HOME="$mounted_output/ros-home" ROS_LOG_DIR="$mounted_output/ros-logs" \
  roslaunch --no-summary "$mounted_output/manual.launch" "$@" 2>&1 \
  | python3 "$here/console_filter.py" --log "$run_output/console.log"
