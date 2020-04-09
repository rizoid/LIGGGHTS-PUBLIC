# Perform initialization of liggghts variables
IF(NOT LIGGGHTS_INITIALIZED)
	SET(LIGGGHTS_INITIALIZED 1)

	# Mark this as Liggghts Include Path
	SET(LIGGGHTS_INCLUDE ${CMAKE_CURRENT_LIST_DIR}/../)

	IF (NOT CMAKE_CXX_FLAGS)
		#If flags are not set, add default flags
		SET(CMAKE_BUILD_TYPE Release)
		SET(CMAKE_CXX_FLAGS  " -Wall -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wformat-security -Werror=format-security")
	ENDIF (NOT CMAKE_CXX_FLAGS)

	#=======================================

	OPTION(USE_VTK "Whether or not VTK shall be used" OFF)
	IF(USE_VTK)
		#INCLUDE(FindVTK)
		FIND_PACKAGE(VTK)
		IF(VTK_FOUND)
			INCLUDE(${VTK_USE_FILE})
			ADD_DEFINITIONS("-DLAMMPS_VTK")
			MESSAGE(STATUS "Found VTK")

			#FIND_PACKAGE(Eigen3 REQUIRED)
			#INCLUDE_DIRECTORIES(${EIGEN3_INCLUDE_DIR})
			#MESSAGE(STATUS "Found Eigen3")
		ELSE(VTK_FOUND)
			MESSAGE(STATUS "VTK NOT found!")
		ENDIF(VTK_FOUND)
	ENDIF(USE_VTK)

	#=======================================

	OPTION(USE_JPEG "Whether or not JPEG shall be used" OFF)
	IF(USE_JPEG)
		INCLUDE(FindJPEG)
		IF(JPEG_FOUND)
			INCLUDE_DIRECTORIES(${JPEG_INCLUDE_DIR})
			ADD_DEFINITIONS("-DLAMMPS_JPEG")
		ELSE(JPEG_FOUND)
			MESSAGE(STATUS "JPEG NOT found!")
		ENDIF(JPEG_FOUND)
	ENDIF(USE_JPEG)

	#=======================================
	INCLUDE(FindMPI)
	# One should not modify CMAKE_C_COMPILER explicitly. Is it really required?
	#IF(MPI_C_FOUND AND MPI_CXX_FOUND)
	#	SET(CMAKE_C_COMPILER ${MPI_C_COMPILER})
	#	SET(CMAKE_CXX_COMPILER ${MPI_CXX_COMPILER})
	#ELSE(MPI_C_FOUND AND MPI_CXX_FOUND)
	#	#Check old FindMPI version
	#	IF(MPI_COMPILER)
	#		SET(CMAKE_C_COMPILER ${MPI_COMPILER})
	#		SET(CMAKE_CXX_COMPILER ${MPI_COMPILER})
	#	ELSE(MPI_COMPILER)
	#		MESSAGE(FATAL_ERROR "MPI-COMPILER NOT found!")
	#	ENDIF(MPI_COMPILER)
	#ENDIF(MPI_C_FOUND AND MPI_CXX_FOUND)
	INCLUDE_DIRECTORIES(${MPI_C_INCLUDE_PATH})

	#=======================================

	# Visual Studio requires boost as it does not know the erf and erfc functions
	IF(WIN32)
		#INCLUDE(FindBoost)
		#INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIR})

		# Windows requires inttypes.h
		INCLUDE_DIRECTORIES(${CMAKE_CURRENT_LIST_DIR}/../WINDOWS/extra)

	ENDIF(WIN32)

	#=======================================

	# Visual Studio specific options
	IF(MSVC)
		# Disable warnings about unsafe functions
		ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS)
		# Disable definition of min/max to avoid warnings
		ADD_DEFINITIONS(-DNOMINMAX)
		#add_definitions(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE)
		# Definition to get constants like M_PI
		ADD_DEFINITIONS(-D_USE_MATH_DEFINES)
		# Disable Warnings
		# 4101 = lokale Variable wird nicht verwendet
		# 4244 = Konvertierung unterschiedlich grosser Datentypen
		# 4267 = Konvertierung unterschiedlich grosser Datentypen
		ADD_DEFINITIONS( "/wd4101 /wd4244 /wd4267" )
		
		# Disable Optimization for RelWithDebInfo
		STRING(REPLACE "/O2" "/Od" CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
	ENDIF(MSVC)	

ENDIF()
