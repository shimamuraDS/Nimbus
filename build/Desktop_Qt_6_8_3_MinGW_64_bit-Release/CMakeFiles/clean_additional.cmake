# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Release")
  file(REMOVE_RECURSE
  "CMakeFiles\\WeatherApp_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\WeatherApp_autogen.dir\\ParseCache.txt"
  "WeatherApp_autogen"
  "tests\\CMakeFiles\\tst_AlertCondition_autogen.dir\\AutogenUsed.txt"
  "tests\\CMakeFiles\\tst_AlertCondition_autogen.dir\\ParseCache.txt"
  "tests\\CMakeFiles\\tst_HourlyMerge_autogen.dir\\AutogenUsed.txt"
  "tests\\CMakeFiles\\tst_HourlyMerge_autogen.dir\\ParseCache.txt"
  "tests\\CMakeFiles\\tst_HttpService_autogen.dir\\AutogenUsed.txt"
  "tests\\CMakeFiles\\tst_HttpService_autogen.dir\\ParseCache.txt"
  "tests\\tst_AlertCondition_autogen"
  "tests\\tst_HourlyMerge_autogen"
  "tests\\tst_HttpService_autogen"
  )
endif()
