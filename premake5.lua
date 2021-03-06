
is_64_bit = true

coverage_test = false



linux, windows = 1, 2

build_os = linux

if package.config:sub(1,1) == '\\' then
    build_os = windows
end

workspace "Labyri"
    language "C"
    cdialect "C11"

    location "build"

    if is_64_bit then
        architecture "x86_64"
    else
        architecture "x86"
    end

    configurations { "Debug", "Release" }

    filter { "configurations:Debug" }
        symbols "On"
        optimize "Off"

    filter { "configurations:Release" }
        symbols "Off"
        optimize "Speed"
        linkoptions  { "-flto" }
        
    filter { }

    targetdir ("build/bin/")

    objdir ("build/obj/")


project "lab"
    kind "ConsoleApp"

    includedirs "src"
    includedirs "lib/LabyriCUtils/src"

    files {
        "src/main.c",
        "src/lexer.c",
        "src/parser.c",
        "src/vm.c",
        "src/repl.c",
        "src/utilities.c",
    }

    if is_64_bit then
        defines { "LAB_64_BIT" }
    else 
        defines { "LAB_32_BIT" }
    end

    filter "configurations:Debug"
        defines { "DEBUG" }

        if build_os == linux and coverage_test then 
            buildoptions { "-fprofile-arcs", "-ftest-coverage" }
            linkoptions  { "-fprofile-arcs", "-ftest-coverage" }
        end

    filter "configurations:Release"
        defines { "NDEBUG" }

    filter {}

    libdirs { "lib/LabyriCUtils/build/bin/" }
    links { "labcutils" }


project "labyri" -- Static library for embedding
    kind "StaticLib"

    includedirs "src"
    includedirs "lib/LabyriCUtils/src"

    files {
        "src/lexer.c",
        "src/parser.c",
        "src/vm.c",
        "src/repl.c",
        "src/utilities.c",
    }

    if is_64_bit then
        defines { "LAB_64_BIT" }
    else 
        defines { "LAB_32_BIT" }
    end

    filter "configurations:Debug"
        defines { "DEBUG" }

        if build_os == linux and coverage_test then 
            buildoptions { "-fprofile-arcs", "-ftest-coverage" }
            linkoptions  { "-fprofile-arcs", "-ftest-coverage" }
        end

    filter "configurations:Release"
        defines { "NDEBUG" }

    filter {}

    libdirs { "lib/LabyriCUtils/build/bin/" }
    links { "labcutils" }