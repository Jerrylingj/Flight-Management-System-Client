cmake_minimum_required(VERSION 3.16)

# Flight_Management_System_Client 为项目名
project(Flight_Management_System_Client VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)                   # 源编译
set(CMAKE_AUTORCC ON)                   # 执行文件
set(CMAKE_CXX_STANDARD 17)              # C++ 17
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

set(QML_FILES
    Main.qml
    MainWindow.qml
    views/HomeView.qml
    views/FlightInfoView.qml
    views/OrdersView.qml
    views/ProfileView.qml
    views/FindView.qml
    views/FlightInfoEditView.qml
    views/ClientServerView.qml
    views/AgentServerView.qml
    views/OrderDetailView.qml
    views/LoginView.qml
    views/RegisterView.qml
    views/FlightFavoriteView.qml
    views/EditPersonalInfo.qml
    views/UsersInfoView.qml
    views/AboutView.qml
    components/FlightInfoCard.qml
    components/NoteCard.qml
    components/NoteList.qml
    components/MessageItem.qml
    components/TimeProgressBar.qml
    components/OrderInfoCard.qml
    components/AddressPicker.qml
    components/RechargeEntry.qml
    components/FlightFavoriteCard.qml
)

set(SOURCE_FILES
    main.cpp
    api/networkhandler.cpp
    api/networkhandler.h
    static/sites.js
    storage/userinfo.h
    storage/message.h
)

set(RESOURCES_FILES
    favicon.ico
    figures/homepage-cover.png
    figures/editinfo.png
    figures/login-flight.png
    figures/help-desk.png
    figures/avatar.jpg
    # figures/avatar.png
    figures/nailong.jpg
    figures/user.png
    figures/NailongAskYou.jpg
    figures/NailongAskYouAgain.jpg
    figures/NailongAskYouLastOne.png
    # figures/background1.jpg
    # figures/background2.jpg
    # figures/background3.jpg
    # figures/background4.jpg
    # figures/background5.jpg
    # figures/background6.jpg
    figures/lgj.png
    figures/lsy.png
    figures/ypx.png
    figures/zxy.png
    # figures/personnel.png
)

qt_add_executable(${PROJECT_NAME}
    ${SOURCE_FILES}
)

qt_add_qml_module(${PROJECT_NAME}
    URI Flight_Management_System_Client
    VERSION 1.0
    RESOURCE_PREFIX /qt
    SOURCES ${SOURCE_FILES}
    RESOURCES ${RESOURCES_FILES}
    QML_FILES ${QML_FILES}
    RESOURCES figures/avatar.png
    RESOURCES figures/background1.jpg figures/background2.jpg figures/background3.jpg figures/background4.jpg figures/background5.jpg figures/background6.jpg
    RESOURCES figures/personnel.png
    QML_FILES components/RebookFlightInfoCard.qml
    QML_FILES components/FilterBar.qml
)

# Qt f
# RESOURCES figures/NailongAskYouAgain.jpg
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${PROJECT_NAME} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.${PROJECT_NAME}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE Qt6::Quick
)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/
)

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
