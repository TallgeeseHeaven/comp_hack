# This file is part of COMP_hack.
#
# Copyright (C) 2010-2020 COMP_hack Team <compomega@tutanota.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

IF(USE_EXTERNAL_BINARIES)
    MESSAGE("-- Using external binaries civet")

    ADD_CUSTOM_TARGET(civet)

    SET(INSTALL_DIR "${CMAKE_SOURCE_DIR}/binaries/civet")

    SET(CIVETWEB_INCLUDE_DIRS "${INSTALL_DIR}/include")

    ADD_LIBRARY(civetweb STATIC IMPORTED)

    IF(WIN32)
        SET_TARGET_PROPERTIES(civetweb PROPERTIES
            IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetwebd${CMAKE_STATIC_LIBRARY_SUFFIX}")
    ELSE()
        SET_TARGET_PROPERTIES(civetweb PROPERTIES IMPORTED_LOCATION
            "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb${CMAKE_STATIC_LIBRARY_SUFFIX}")
    ENDIF()

    SET_TARGET_PROPERTIES(civetweb PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${CIVETWEB_INCLUDE_DIRS}")

    ADD_LIBRARY(civetweb-cxx STATIC IMPORTED)
    ADD_DEPENDENCIES(civetweb-cxx civetweb)

    IF(WIN32)
        SET_TARGET_PROPERTIES(civetweb-cxx PROPERTIES
            IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-libraryd${CMAKE_STATIC_LIBRARY_SUFFIX}")
    ELSE()
        SET_TARGET_PROPERTIES(civetweb-cxx PROPERTIES IMPORTED_LOCATION
            "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library${CMAKE_STATIC_LIBRARY_SUFFIX}")
    ENDIF()

    SET_TARGET_PROPERTIES(civetweb-cxx PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${CIVETWEB_INCLUDE_DIRS}")
ELSE(USE_EXTERNAL_BINARIES)
    MESSAGE("-- Building external civet")

    IF(EXISTS "${CMAKE_SOURCE_DIR}/deps/civetweb.zip")
        SET(CIVET_URL
            URL "${CMAKE_SOURCE_DIR}/deps/civetweb.zip"
        )
    ELSEIF(GIT_DEPENDENCIES)
        SET(CIVET_URL
            GIT_REPOSITORY https://github.com/comphack/civetweb.git
            GIT_TAG comp_hack
        )
    ELSE()
        SET(CIVET_URL
            URL https://github.com/comphack/civetweb/archive/comp_hack-20200402.zip
            URL_HASH SHA1=d032dbe54a370aa255066b6920b96dced9a10356
        )
    ENDIF()

    ExternalProject_Add(
        civet

        ${CIVET_URL}

        DEPENDS openssl

        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/civetweb
        CMAKE_ARGS ${CMAKE_RELWITHDEBINFO_OPTIONS} -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DOPENSSL_ROOT_DIR=${OPENSSL_ROOT_DIR}" -DBUILD_TESTING=OFF -DCIVETWEB_LIBRARIES_ONLY=ON -DCIVETWEB_ENABLE_SLL=ON -DCIVETWEB_ENABLE_SSL_DYNAMIC_LOADING=OFF -DCIVETWEB_ALLOW_WARNINGS=ON -DCIVETWEB_ENABLE_CXX=ON "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d -DUSE_SYSTEM_OPENSSL=${USE_SYSTEM_OPENSSL}

        # Dump output to a log instead of the screen.
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON

        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb${CMAKE_STATIC_LIBRARY_SUFFIX}
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library${CMAKE_STATIC_LIBRARY_SUFFIX}

        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetwebd${CMAKE_STATIC_LIBRARY_SUFFIX}
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-libraryd${CMAKE_STATIC_LIBRARY_SUFFIX}

        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}
    )

    ExternalProject_Get_Property(civet INSTALL_DIR)

    SET_TARGET_PROPERTIES(civet PROPERTIES FOLDER "Dependencies")

    SET(CIVETWEB_INCLUDE_DIRS "${INSTALL_DIR}/include")

    FILE(MAKE_DIRECTORY "${CIVETWEB_INCLUDE_DIRS}")

    ADD_LIBRARY(civetweb STATIC IMPORTED)
    ADD_DEPENDENCIES(civetweb civet)

    IF(WIN32)
        SET_TARGET_PROPERTIES(civetweb PROPERTIES
            IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetwebd${CMAKE_STATIC_LIBRARY_SUFFIX}")
    ELSE()
        SET_TARGET_PROPERTIES(civetweb PROPERTIES IMPORTED_LOCATION
            "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb${CMAKE_STATIC_LIBRARY_SUFFIX}")
    ENDIF()

    SET_TARGET_PROPERTIES(civetweb PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${CIVETWEB_INCLUDE_DIRS}")

    ADD_LIBRARY(civetweb-cxx STATIC IMPORTED)
    ADD_DEPENDENCIES(civetweb-cxx civetweb)

    IF(WIN32)
        SET_TARGET_PROPERTIES(civetweb-cxx PROPERTIES
            IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-libraryd${CMAKE_STATIC_LIBRARY_SUFFIX}")
    ELSE()
        SET_TARGET_PROPERTIES(civetweb-cxx PROPERTIES IMPORTED_LOCATION
            "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library${CMAKE_STATIC_LIBRARY_SUFFIX}")
    ENDIF()

    SET_TARGET_PROPERTIES(civetweb-cxx PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${CIVETWEB_INCLUDE_DIRS}")
ENDIF(USE_EXTERNAL_BINARIES)