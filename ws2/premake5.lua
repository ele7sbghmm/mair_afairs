workspace("ws2_workspace")
configurations({ "Debug" })
architecture("arm64")

project("ws2_project")
kind("ConsoleApp")
language("C++")
cppdialect("C++23")
targetdir("bin/%{cfg.buildcfg}")

files({ "src/**.cpp" })

includedirs({
	"vendor/uSockets/src",
	"vendor/uWebSockets/src",
})

files({
	"vendor/uSockets/src/**.cpp",
})

defines({ "UWS_NO_ZLIB" })

filter("configurations:Debug")
symbols("On")
