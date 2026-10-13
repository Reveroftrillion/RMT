cmake_minimum_required(VERSION 3.0.2)
project(foscar_lidar)
find_package(catkin REQUIRED)
catkin_python_setup()
catkin_package()
set(_foscar_python_sources
  scripts/obstacle_node
  scripts/lidar_bridge
  scripts/lidar_monitor
  scripts/lidar_view
  scripts/fake_cloud
)
set(_foscar_python_configured)
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/python_scripts")
foreach(_foscar_script IN LISTS _foscar_python_sources)
  get_filename_component(_foscar_name "${_foscar_script}" NAME)
  set(_foscar_destination "${CMAKE_CURRENT_BINARY_DIR}/python_scripts/${_foscar_name}")
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/${_foscar_script}" "${_foscar_destination}" COPYONLY)
  file(READ "${_foscar_destination}" _foscar_contents)
  string(REGEX REPLACE "^#![^\n]*" "#!${PYTHON_EXECUTABLE}" _foscar_contents "${_foscar_contents}")
  file(WRITE "${_foscar_destination}" "${_foscar_contents}")
  list(APPEND _foscar_python_configured "${_foscar_destination}")
endforeach()
catkin_install_python(PROGRAMS ${_foscar_python_configured}
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})
install(DIRECTORY rviz/ DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/rviz)
install(DIRECTORY launch/ DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/launch FILES_MATCHING PATTERN "*.launch")
