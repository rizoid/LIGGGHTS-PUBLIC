# Include Macros
Include(Macros)

# Module
MACRO(LIGGGHTS_MODULE modname)

	# Define Option
	OPTION(ENABLE_${modname} "Enable module ${modname}" OFF)

	# Save path to module
	SET(liggghts_include_${modname} ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "Include Path of module ${modName}")

	IF(ENABLE_${modname})

		# Check that LIGGGHTS_INCLUDE is defined, otherwise MODULE has been added too early
		IF(NOT LIGGGHTS_INCLUDE)
			MESSAGE("LIGGGHTS_INCLUDE is not defined. Module will not work properly!")
		ENDIF()
		# Check that this library will not be ignored
		IF (LIGGGHTS_TARGET_LIBRARIES_LINKED)
			MESSAGE("Module must be included earlier. Liggghts project has already been finished!")
		ENDIF()

		# Create own library for module
		ADD_LIBRARY(${modname} ${ARGN})

		# Include Liggghts directory
		INCLUDE_DIRECTORIES(${LIGGGHTS_INCLUDE})

		# List of all available modules
		GET_PROPERTY(active_liggghts_modules_local GLOBAL PROPERTY active_liggghts_modules)
		SET_PROPERTY(GLOBAL PROPERTY active_liggghts_modules ${active_liggghts_modules_local} ${modname})

		# Additional Include Directories for main program
		GET_PROPERTY(additional_includes_local GLOBAL PROPERTY additional_includes)
		SET_PROPERTY(GLOBAL PROPERTY additional_includes ${additional_includes_local} ${CMAKE_CURRENT_SOURCE_DIR})

		# Scan for styles
		SCAN_STYLES()

	ENDIF()

ENDMACRO(LIGGGHTS_MODULE)

# Style
MACRO(ADD_STYLE styleName fileName)

    # Get global style list
    GET_PROPERTY(style_${styleName}_local GLOBAL PROPERTY style_${styleName})
	 # Append filename
	 SET(style_${styleName}_local ${style_${styleName}_local} ${fileName})
	 # Save to global style list
    SET_PROPERTY(GLOBAL PROPERTY style_${styleName} ${style_${styleName}_local})

ENDMACRO()



MACRO(WRITE_WHITELIST)
SET(fileName ${CMAKE_CURRENT_SOURCE_DIR}/style_contact_model.h)
# Create File
GETDATETIME(now "%Y-%m-%d %H:%M:%S")
FILE(WRITE ${fileName} "/* created on ${now} */\n")

GET_PROPERTY(normal_models_local GLOBAL PROPERTY normal_models)
GET_PROPERTY(tangential_models_local GLOBAL PROPERTY tangential_models)
GET_PROPERTY(cohesion_models_local GLOBAL PROPERTY cohesion_models)
GET_PROPERTY(rolling_models_local GLOBAL PROPERTY rolling_models)
GET_PROPERTY(surface_models_local GLOBAL PROPERTY surface_models)

SET(N 0)
foreach(nm ${normal_models_local})
 foreach(tm ${tangential_models_local})
  foreach(cm ${cohesion_models_local})
  foreach(rm ${rolling_models_local})
   foreach(sm ${surface_models_local}) 
     #message("Enabling ${nm} & ${tm} & ${cm} & ${rm} & ${sm}")
     MATH(EXPR N "${N}+1")
     FILE(APPEND ${fileName} "GRAN_MODEL(${nm}, ${tm}, ${cm}, ${rm}, ${sm})\n")
    endforeach()
   endforeach()
  endforeach()
 endforeach()
endforeach()
message("There are ${N} contact model combinations")
ENDMACRO()

MACRO(ADD_CONTACT_MODEL normal_model tangential_model cohesion_model rolling_model surface_model)
 GET_PROPERTY(normal_models_local GLOBAL PROPERTY normal_models)
 GET_PROPERTY(tangential_models_local GLOBAL PROPERTY tangential_models)
 GET_PROPERTY(cohesion_models_local GLOBAL PROPERTY cohesion_models) 
 GET_PROPERTY(rolling_models_local GLOBAL PROPERTY rolling_models)
 GET_PROPERTY(surface_models_local GLOBAL PROPERTY surface_models)
 
 SET_PROPERTY(GLOBAL PROPERTY normal_models "${normal_models_local}" "${normal_model}")
 SET_PROPERTY(GLOBAL PROPERTY tangential_models "${tangential_models_local}" "${tangential_model}")
 SET_PROPERTY(GLOBAL PROPERTY cohesion_models "${cohesion_models_local}" "${cohesion_model}")
 SET_PROPERTY(GLOBAL PROPERTY rolling_models "${rolling_models_local}" "${rolling_model}")
 SET_PROPERTY(GLOBAL PROPERTY surface_models "${surface_models_local}" "${surface_model}")
ENDMACRO()

# Scan for Styles
MACRO(SCAN_STYLE searchExpression fileFilter styleName)

	# Get all files that match filter expression
	FILE(GLOB file_list RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${fileFilter})

	# Go through each file
	FOREACH(fileName ${file_list})
		# add full path
		SET(fileName ${CMAKE_CURRENT_SOURCE_DIR}/${fileName})

		# Read each file
		FILE(READ ${fileName} fileContent)
		# Does the file contain the searchExpression
		SET(pos -1)
		STRING(FIND "${fileContent}" ${searchExpression} pos)
		# If searchExpression is in fileContent
		IF(pos GREATER -1)
			ADD_STYLE(${styleName} ${fileName})
		ENDIF()
	ENDFOREACH()

ENDMACRO()

# Scan for all known styles
MACRO(SCAN_STYLES)

  SCAN_STYLE( ANGLE_CLASS     			angle_*.h      			angle)
  SCAN_STYLE( ATOM_CLASS      			atom_vec_*.h   			atom)
  SCAN_STYLE( BOND_CLASS      			bond_*.h       			bond)
  SCAN_STYLE( COMMAND_CLASS   			*.h          			command)
  SCAN_STYLE( COMPUTE_CLASS   			compute_*.h    			compute)
  SCAN_STYLE( DIHEDRAL_CLASS  			dihedral_*.h   			dihedral)
  SCAN_STYLE( DUMP_CLASS      			dump_*.h       			dump)
  SCAN_STYLE( FIX_CLASS       			fix_*.h        			fix)
  SCAN_STYLE( IMPROPER_CLASS  			improper_*.h   			improper)
  SCAN_STYLE( INTEGRATE_CLASS 			*.h          			integrate)
  SCAN_STYLE( KSPACE_CLASS    			*.h          			kspace)
  SCAN_STYLE( MINIMIZE_CLASS  			min_*.h        			minimize)
  SCAN_STYLE( PAIR_CLASS      			pair_*.h       			pair)
  SCAN_STYLE( REGION_CLASS    			region_*.h     			region)
  SCAN_STYLE( CFD_DATACOUPLING_CLASS 	cfd_datacoupling_*.h	cfd_datacoupling)
  SCAN_STYLE( CFD_REGIONMODEL_CLASS  	cfd_regionmodel_*.h  	cfd_regionmodel)
  SCAN_STYLE( LB_CLASS        			*.h          			lb)
  SCAN_STYLE( SPH_KERNEL_CLASS  		sph_kernel_*.h  		sph_kernel)
  SCAN_STYLE( SURFACE_MODEL  		    surface_model_*.h  		surface_model)
  SCAN_STYLE( NORMAL_MODEL  		    normal_model_*.h  		normal_model)
  SCAN_STYLE( TANGENTIAL_MODEL  		tangential_model_*.h  	tangential_model)
  SCAN_STYLE( ROLLING_MODEL  			rolling_model_*.h  	    rolling_model)
  SCAN_STYLE( COHESION_MODEL  			cohesion_model_*.h  	cohesion_model)
  SCAN_STYLE( MESH_MOVER  			    mesh_mover_*.h  	    mesh_mover)
  SCAN_STYLE( MESH_MODULE  			    mesh_module_*.h  	    mesh_module)
  SCAN_STYLE( READER  			    	reader_*.h  	        reader)

ENDMACRO()

MACRO(GEN_STYLE styleName)

	# Get global style list
		GET_PROPERTY(styleFileList GLOBAL PROPERTY style_${styleName})

	# Filename
	SET(fileName ${CMAKE_CURRENT_SOURCE_DIR}/style_${styleName}.h)
	# Delete file if exists
	IF(EXISTS ${fileName})
		FILE(REMOVE ${fileName})
	ENDIF()

	# Create File
	GETDATETIME(now "%Y-%m-%d %H:%M:%S")
	FILE(WRITE ${fileName} "/* created on ${now} */\n")

	# Append includes
	FOREACH(styleFile ${styleFileList})
		FILE(APPEND ${fileName} "\#include \"${styleFile}\"\n")
	ENDFOREACH()

ENDMACRO()

MACRO(GEN_STYLES)

  # Generate all style files
  GEN_STYLE(angle)
  GEN_STYLE(atom)
  GEN_STYLE(bond)
  GEN_STYLE(command)
  GEN_STYLE(compute)
  GEN_STYLE(dihedral)
  GEN_STYLE(dump)
  GEN_STYLE(fix)
  GEN_STYLE(improper)
  GEN_STYLE(integrate)
  GEN_STYLE(kspace)
  GEN_STYLE(minimize)
  GEN_STYLE(pair)
  GEN_STYLE(region)
  GEN_STYLE(cfd_datacoupling)
  GEN_STYLE(cfd_regionmodel)
  GEN_STYLE(lb)
  GEN_STYLE(sph_kernel)
  GEN_STYLE(surface_model)
  GEN_STYLE(normal_model)
  GEN_STYLE(tangential_model)
  GEN_STYLE(rolling_model)
  GEN_STYLE(cohesion_model)
  GEN_STYLE(mesh_mover)
  GEN_STYLE(mesh_module)
  GEN_STYLE(reader)

ENDMACRO()

MACRO(DEPENDENCY currentModule)

	IF(ENABLE_${currentModule})
		FOREACH(modname ${ARGV})
			IF(NOT ${modname} STREQUAL ${currentModule})
				# Test if enabled
				IF(ENABLE_${modname})
					# Include Directory
					INCLUDE_DIRECTORIES(${liggghts_include_${modname}})
				ELSE(ENABLE_${modname})
					MESSAGE("${currentModule} depends on ${modname} which is disabled!")
				ENDIF(ENABLE_${modname})
			ENDIF(NOT ${modname} STREQUAL ${currentModule})
		ENDFOREACH(modname ${ARGV})
	ENDIF(ENABLE_${currentModule})

ENDMACRO()
