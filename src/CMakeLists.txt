set(plasmoidplugin_SRCS
        plugin.cpp
        plugin.h
        plasmai3workspaces.cpp
        plasmai3workspaces.h)

add_library(plasmoidplugin SHARED ${plasmoidplugin_SRCS})

target_link_libraries(plasmoidplugin Qt5::Quick KF5::Plasma)

install(TARGETS plasmoidplugin DESTINATION ${QML_INSTALL_DIR}/PlasmaI3Workspaces)
install(FILES qmldir DESTINATION ${QML_INSTALL_DIR}/PlasmaI3Workspaces)
