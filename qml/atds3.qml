import Qt.labs.platform 1.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtMultimedia 5.12
import cu.atds3 1.0
import "qrc:/qml/configuracion"
import "qrc:/qml/principal"


ApplicationWindow {
//	property bool orientacionHorizontal: (ventanaPrincipal.width > ventanaPrincipal.height)
    property bool orientacionHorizontal: true
	property color colorPrimario: Material.color(colorTemaPrimario(), Material.Shade800)
	property int colorAcento: colorTemaPrimario()
	property int tamanoIconos: obtenerTamanoIconos()
	property string estadoListadoCategorias: configuraciones.valor("atds3/estadoListadoCategorias", "expandido")
	property int categoriaActual: configuraciones.valor("atds3/ultimaCategoriaSeleccionada", 0)
	property alias modeloIconoCategorias: modeloIconoCategorias
	property alias modeloCategorias: modeloCategorias
	property alias modeloPaquetes: modeloPaquetes
	property alias pantallaConfiguracion: pantallaConfiguracion
	property alias pantallaPrincipal: pantallaPrincipal
	property alias pantallaCodigoVerificacion: pantallaCodigoVerificacion
	property alias pantallaPublicarContenido: pantallaPublicarContenido
	property alias vistaApilable: vistaApilable
//	property alias bandejaIconos: bandejaIconos

	id: ventanaPrincipal
	font.pointSize: tamanoIconos === 48 ? 12 : 10
	height: 620
    width: 1080
	visible: true
//    visibility: Window.Maximized

	Configuraciones {
		id: configuraciones
	}

	function mostrarOcultarVentana() {
		if (ventanaPrincipal.visible === true) {
			hide()
		} else {
			show()
			raise()
			requestActivate()
		}
	}

	function colorTemaPrimario() {
		let color;

		switch (parseInt(configuraciones.valor("atds3/temaColores", 4))) {
			case 0: // Amarillo
				color = Material.Yellow;
				break;
			case 1: // Ámber
				color = Material.Amber;
				break;
			case 2: // Azul
				color = Material.Blue;
				break;
			case 3: // Azul claro
				color = Material.LightBlue;
				break;
			case 4: // Azul oscuro
				color = Material.Indigo;
				break;
			case 5: // Cian
				color = Material.Cyan;
				break;
			case 6: // Gris
				color = Material.Grey;
				break;
			case 7: // Gris azulado
				color = Material.BlueGrey;
				break;
			case 8: // Marrón
				color = Material.Brown;
				break;
			case 9: // Naranja
				color = Material.Orange;
				break;
			case 10: // Naranja profundo
				color = Material.DeepOrange;
				break;
			case 11: // Púrpura
				color = Material.Purple;
				break;
			case 12: // Púrpura oscuro
				color = Material.DeepPurple;
				break;
			case 13: // Rojo
				color = Material.Red;
				break;
			case 14: // Rosado
				color = Material.Pink;
				break;
			case 15: // Verde
				color = Material.Green;
				break;
			case 16: // Verde azulado
				color = Material.Teal;
				break;
			case 17: // Verde claro
				color = Material.LightGreen;
				break;
			case 18: // Verde lima
				color = Material.Lime;
				break;
		}

		return color;
	}

	function actualizarTemaColores() {
		colorPrimario = Material.color(colorTemaPrimario(), Material.Shade800)
		colorAcento = colorTemaPrimario()
	}

	function obtenerTamanoIconos() {
		let valor = parseInt(configuraciones.valor("atds3/tamanoIconos", 0))

		if (valor < 0) {
			valor = 0;
		}
		if (valor > 1) {
			valor = 1
		}

		switch (valor) {
			case 0:
				return 32
			default:
				return 48
		}
	}

	function actualizarTamanoIconos(valor) {
		configuraciones.establecerValor("atds3/tamanoIconos", valor)
		tamanoIconos = obtenerTamanoIconos()
	}

	function actualizarEstadoListadoCategorias(valor) {
		configuraciones.establecerValor("atds3/estadoListadoCategorias", valor)
		estadoListadoCategorias = valor
	}

	function visualizarTareaIniciada(idCategoria, idPaquete, filaPaquete, filaTarea) {
		let filaCategoria = 0

		for (let f = 0; f < modeloCategorias.rowCount(); f++) {
			let registroCategoria = modeloCategorias.obtener(f)

			if (registroCategoria.id === idCategoria) {
				filaCategoria = f;
				break;
			}
		}

		if (pantallaPrincipal.vistaCategorias.listadoCategorias.currentIndex === filaCategoria) {
			if (pantallaPrincipal.vistaPaquetes.listadoPaquetes.currentIndex === filaPaquete) {
				if (pantallaPrincipal.vistaPaquetes.listadoPaquetes.currentItem !== null) {
					pantallaPrincipal.vistaPaquetes.listadoPaquetes.currentItem.listadoTareas.currentIndex = filaTarea
				}
			}
		}
	}

	function mostrarPantallaCodigoVerificacion() {
		pantallaCodigoVerificacion.mostrar();
	}

	function mostrarPantallaFalloInicioSesion(error) {
		pantallaFalloInicioSesion.mostrar(error);
	}

	Audio {
		id: reproductorNotificacion
		audioRole: Audio.NotificationRole
	}

	function reproducirNotificacion(archivo) {
		reproductorNotificacion.source = `qrc:/mp3/${configuraciones.valor("notificaciones/temaSonidos", "encantado")}/${archivo}`
		reproductorNotificacion.play()
	}

	function actualizarIndicadorDisponibilidadTodus(estado) {
		pantallaPrincipal.vistaCategorias.indicadorDisponibilidadTodus.state = estado
	}

	Material.primary: colorPrimario
	Material.accent: colorAcento

	Shortcut {
		sequence: "Ctrl+Q"
		onActivated: Qt.quit(0)
	}
	Shortcut {
		sequences: ["Esc", "Back"]
		enabled: (vistaApilable.depth > 1)
		onActivated: vistaApilable.pop()
	}

	SystemPalette { id: paletaSistema; colorGroup: SystemPalette.Active }

	ModeloCategorias {
		id: modeloCategorias
	}

	ModeloIconoCategorias {
		id: modeloIconoCategorias
	}

	ModeloPaquetes {
		id: modeloPaquetes
	}

	Configuracion {
		id: pantallaConfiguracion
		visible: false
	}

	Principal {
		id: pantallaPrincipal
		visible: false
	}

	CodigoVerificacion {
		id: pantallaCodigoVerificacion
		visible: false
	}

	FalloInicioSesion {
		id: pantallaFalloInicioSesion
		visible: false
	}

	PublicarContenido {
		id: pantallaPublicarContenido
		visible: false
	}

	StackView {
		id: vistaApilable
		anchors.fill: parent
		initialItem: pantallaPrincipal
	}
/*
	SystemTrayIcon {
		id: bandejaIconos
		iconSource: "qrc:/svg/atds3.svg"
		visible: true
		menu: Menu {
			MenuItem {
				iconSource: "qrc:/svg/eye.svg"
				text: ventanaPrincipal.visible === true ? "Ocultar" : "Mostrar"
				onTriggered: mostrarOcultarVentana()
			}
			MenuSeparator {}
			MenuItem {
				iconSource: "qrc:/svg/window-close.svg"
				text: "Terminar"
				onTriggered: Qt.quit()
			}
		}

		onActivated: mostrarOcultarVentana()
	}
*/
	Component.onCompleted: {
		let categoria = modeloCategorias.obtener(configuraciones.valor("atds3/ultimaCategoriaSeleccionada", 0))

		modeloPaquetes.establecerFiltroCategoria(categoria.id)
	}
}
