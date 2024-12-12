# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appFlight_Management_System_Client_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appFlight_Management_System_Client_autogen.dir\\ParseCache.txt"
  "appFlight_Management_System_Client_autogen"
  )
endif()
