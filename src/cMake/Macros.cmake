# Name: get_subdirs
# Description: Scan and return all subdirectories that contain the filename
# specified.
# Usage: get_subdirs(list_returned_here filename-to-find)
# Example: get_subdirs(dir-list "CMakeLists.txt")
macro(get_subdirs retval filename)
# Search from current directory for filename specified
file(GLOB file-list RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} */${filename})

# Return relative path to each directory found
set(dir-list "")
foreach(item ${file-list})
get_filename_component(file-path ${item} PATH)
set(dir-list ${dir-list} ${file-path})
endforeach()
set(${retval} ${dir-list})
endmacro(get_subdirs)


# Name: command_to_configvar
# Description: Run a command and save output in variable
# Usage: command_to_configvar(command_to_run variable-to-store-result-in)
# Example: command_to_configvar(whoami wai)
macro(command_to_configvar command var)
 execute_process(
  COMMAND "${command}"
  OUTPUT_VARIABLE ${var}
  OUTPUT_STRIP_TRAILING_WHITESPACE)
endmacro(command_to_configvar)

macro(GETDATETIME RESULT formatString)

	IF(${CMAKE_VERSION} VERSION_LESS 2.8.11)
		MESSAGE(STATUS "Since CMake does not support TIMESTAMP, current datetime is retrieved via date command. Please update to CMake 2.8.11 or higher.")

		IF(WIN32)
			EXECUTE_PROCESS(COMMAND "date" "/T" OUTPUT_VARIABLE RESULT_DATE)
			EXECUTE_PROCESS(COMMAND "time" "/T" OUTPUT_VARIABLE RESULT_TIME)
			SET(${RESULT} "${RESULT_DATE} ${RESULT_TIME}")
		ELSEIF(UNIX)
			EXECUTE_PROCESS(COMMAND "date" "+${formatString}" OUTPUT_VARIABLE RESULT_DATETIME)
			STRING(STRIP ${RESULT_DATETIME} ${RESULT})
		ELSE()
			MESSAGE(SEND_ERROR "date function not implemented for this operating system!")
		ENDIF()

	ELSE()
		STRING(TIMESTAMP ${RESULT} ${formatString})
	ENDIF()


endmacro()
