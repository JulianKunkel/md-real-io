add_definitions("-DGIT_COMMIT_HASH=${GIT_COMMIT_HASH}")
add_definitions("-DGIT_BRANCH=${GIT_BRANCH}")

add_executable(md-workbench option.c memory.c md_util.c md-workbench.c ${PLUGINS})
target_link_libraries(md-workbench PRIVATE ${MPI_LIBRARIES} ${MONGOC_LIBRARIES} ${LIBPQ_LIBRARIES} ${LIBS3_LIBRARIES} -lm)

set_target_properties(md-workbench PROPERTIES INSTALL_RPATH  ${MONGOC_LIBDIR}:${MPI_LIBDIR}:${LIBPQ_LIBDIR}:${LIBS3_LIBDIR})
set_target_properties(md-workbench PROPERTIES LINK_FLAGS "${MPI_LINK_FLAGS}")
set_target_properties(md-workbench PROPERTIES COMPILE_FLAGS "${MPI_COMPILE_FLAGS}")
target_include_directories(md-workbench SYSTEM PRIVATE ${MPI_INCLUDE_PATH} ${MONGOC_INCLUDE_DIRS} ${LIBPQ_INCLUDE_DIRS} ${LIBS3_INCLUDE_DIRS})


install(TARGETS md-workbench RUNTIME DESTINATION bin)

add_test( NAME dummyRun COMMAND mpiexec -n 2 $ENV{MPI_ARGS} ./md-workbench -i=dummy )
add_test( NAME listModules COMMAND mpiexec -n 2 $ENV{MPI_ARGS} ./md-workbench -i=list )

# complex tests should not be added here. They can be part of the bebug branch such as:

if(LIBPQ_VERSION)
  add_test( NAME postgres CONFIGURATIONS DEBUG COMMAND mpiexec -n 2 $ENV{MPI_ARGS} ./md-workbench -P=1 -I=1 -D=2 -i=postgres -- -D=root -U=root)
endif()

if(MONGOC_VERSION)
  add_test( NAME mongo CONFIGURATIONS DEBUG COMMAND mpiexec -n 2 $ENV{MPI_ARGS} ./md-workbench -P=1 -I=1 -D=2 -i=mongo -- -D=test)
endif()
