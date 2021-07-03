QT += quick quickcontrols2 svg sql network websockets multimedia

CONFIG += c++latest

unix: !android {
	QT += widgets
	CONFIG += x11
}
windows: CONFIG += windows embed_manifest_exe windeployqt

TEMPLATE = app

TARGET = atds3

VERSION = 1.0.0
windows {
	RC_ICONS = recursos/ico/atds3.ico
	QMAKE_TARGET_COMPANY = ATDS3
	QMAKE_TARGET_DESCRIPTION = Administrador de Transferencias para toDus (S3)
	QMAKE_TARGET_COPYRIGHT = Todos los derechos reservados.
	QMAKE_TARGET_PRODUCT = ATDS3.EXE
	RC_LANG = 0x040A
	RC_CODEPAGE = 0x04B0
}

HEADERS += \
	cabeceras/configuraciones.hpp \
	cabeceras/http.hpp \
	cabeceras/todus.pb.h \
	cabeceras/todus.hpp \
	cabeceras/modeloiconocategorias.hpp \
	cabeceras/modelocategorias.hpp \
	cabeceras/modelotareas.hpp \
	cabeceras/modelopaquetes.hpp \
	cabeceras/main.hpp

SOURCES += \
	fuentes/configuraciones.cpp \
	fuentes/http.cpp \
	fuentes/todus.pb.cc \
	fuentes/todus.cpp \
	fuentes/modeloiconocategorias.cpp \
	fuentes/modelocategorias.cpp \
	fuentes/modelotareas.cpp \
	fuentes/modelopaquetes.cpp \
	fuentes/main.cpp

RESOURCES += recursos/recursos.qrc qml.qrc

DISTFILES +=	README.md \
				LICENSE

INCLUDEPATH += cabeceras

unix: QML_IMPORT_PATH += qml
windows: QML_IMPORT_PATH += c:/proyectos/atds3-1.0.0/qml

unix: !android {
	INCLUDEPATH += /usr/include /usr/local/include
	LIBS += -lssl -lcrypto

	CONFIG(protobuf): LIBS += -lprotobuf
	!CONFIG(protobuf) {
		LIBPROTOBUF =	/usr/local/lib/libprotobuf.a \
						/usr/lib/libprotobuf.a \
						/usr/lib64/libprotobuf.a \
						/usr/lib/x86_64-linux-gnu/libprotobuf.a
		for(ruta, LIBPROTOBUF): exists($${ruta}): LIBS += $${ruta}
	}

	unix_desktop_icon.files = recursos/iconos/atds3.svg
	unix_desktop_icon.path = $${QMAKE_PREFIX}/share/pixmaps
	
	unix_desktop.files = atds3.desktop
	unix_desktop.path = $${QMAKE_PREFIX}/share/applications
}

android {
	JAVA_HOME = C:/Program Files/Java/jdk1.8.0_291
	ANDROID_ABIS = armeabi-v7a arm64-v8a
	ANDROID_MIN_SDK_VERSION = 21
	ANDROID_TARGET_SDK_VERSION = 30
#	ANDROID_FEATURES +=
	ANDROID_PERMISSIONS += WRITE_EXTERNAL_STORAGE INTERNET FOREGROUND_SERVICE
	ANDROID_VERSION_CODE = 0x1007
	ANDROID_VERSION_NAME = 1.0.0-CL7

	INCLUDEPATH += C:/proyectos/protobuf-3.16.0/_construccion/android/$${ANDROID_TARGET_ARCH}/include
	LIBS += C:/proyectos/protobuf-3.16.0/_construccion/android/$${ANDROID_TARGET_ARCH}/lib/libprotobuf.a
}

windows {
	INCLUDEPATH +=	C:/msys64/mingw64/include
	
	LIBS += -LC:/msys64/mingw64/lib \
			-lssl -lcrypto C:/msys64/mingw64/lib/libprotobuf.a
}

target.path = $${QMAKE_INSTALL_PREFIX}/bin
INSTALLS += target
unix: !android: INSTALLS += unix_desktop_icon unix_desktop
android: include(C:/android/sdk/android_openssl/openssl.pri)
