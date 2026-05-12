cmake_minimum_required(VERSION 3.10)
project(gooey)

find_package(glfw3 REQUIRED)
set(IMGUI_SOURCES
	imgui/imgui.cpp
	imgui/imgui_draw.cpp
	imgui/imgui_tables.cpp
	imgui/imgui_widgets.cpp
	imgui/imgui_demo.cpp
	imgui_backends/imgui_impl_glfw.cpp
	imgui_backends/imgui_impl_metal.mm
)

add_executable(${PROJECT_NAME} main.mm ${IMGUI_SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE
	imgui
	imgui_backends
)

target_link_libraries(${PROJECT_NAME} PRIVATE glfw)

if (APPLE)
	target_link_libraries(
		${PROJECT_NAME}
		PRIVATE
		"-framework MetalKit"
		"-framework Metal"
		"-framework Cocoa"
		"-framework IOKit"
		"-framework CoreVideo"
		"-framework QuartzCore"
	)
	target_compile_definitions(
		${PROJECT_NAME}
		PRIVATE
		GL_SILENCE_DEPRECATION
	)
endif()

