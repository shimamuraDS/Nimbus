cmake_minimum_required(VERSION 3.16)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Test)

enable_testing()

add_executable(tst_HourlyMerge tst_HourlyMerge.cpp
    ${CMAKE_SOURCE_DIR}/src/data/WeatherCacheManager.cpp
    ${CMAKE_SOURCE_DIR}/src/util/TimeUtil.cpp
)
target_link_libraries(tst_HourlyMerge PRIVATE Qt6::Core Qt6::Test)
target_include_directories(tst_HourlyMerge PRIVATE ${CMAKE_SOURCE_DIR}/src)

add_executable(tst_AlertCondition tst_AlertCondition.cpp
    ${CMAKE_SOURCE_DIR}/src/util/WeatherCode.cpp
    ${CMAKE_SOURCE_DIR}/src/util/TimeUtil.cpp
)
target_link_libraries(tst_AlertCondition PRIVATE Qt6::Core Qt6::Test)
target_include_directories(tst_AlertCondition PRIVATE ${CMAKE_SOURCE_DIR}/src)

add_executable(tst_HttpService tst_HttpService.cpp
    ${CMAKE_SOURCE_DIR}/src/network/HttpClient.cpp
    ${CMAKE_SOURCE_DIR}/src/network/TencentApiClient.cpp
    ${CMAKE_SOURCE_DIR}/src/util/Config.cpp
)
target_link_libraries(tst_HttpService PRIVATE Qt6::Core Qt6::Test Qt6::Network)
target_include_directories(tst_HttpService PRIVATE ${CMAKE_SOURCE_DIR}/src)

add_test(NAME HourlyMerge COMMAND tst_HourlyMerge)
add_test(NAME AlertCondition COMMAND tst_AlertCondition)
add_test(NAME HttpService COMMAND tst_HttpService)
