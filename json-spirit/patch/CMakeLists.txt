cmake_minimum_required(VERSION 2.6)

project(json_spirit)

set(PROJECT_DIR ${PROJECT_SOURCE_DIR})
set(JSON_SPIRIT_INCLUDE_DIR ${PROJECT_DIR}/json_spirit)


install(DIRECTORY
  ${JSON_SPIRIT_INCLUDE_DIR}/
  DESTINATION include/json_spirit
)


