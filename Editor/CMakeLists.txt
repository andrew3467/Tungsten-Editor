cmake_minimum_required(VERSION 3.29)
project(Editor)

set(CMAKE_CXX_STANDARD 23)

add_subdirectory(../Tungsten ../bin)

add_subdirectory(External)


file(GLOB_RECURSE SRC src/*.cpp)
file(GLOB_RECURSE HEADERS src/*.h)


add_executable(
        Editor
        ${SRC}
        ${HEADERS}
)

target_link_libraries(
        Editor
        PRIVATE
        Tungsten
)

target_include_directories(
        Editor
        PRIVATE
        ../Tungsten/src
)