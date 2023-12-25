import QtQuick
import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Dialogs 6.5
import Qt.labs.platform
import QDialogs

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "Forest Inventory"
    maximumHeight: height
    maximumWidth: width

    Rectangle {
        id: retangulo
        visible: true
        width: 640
        height: 480

        Image {
            id: backgroundImage
            source: "images/wallpaper.jpg" // Substitua pelo caminho real da sua imagem
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            width: retangulo.width
            height: retangulo.height
        }

        ComboBox {
            id: comboBox
            anchors.centerIn: parent
            width: 480
            height: 30
            currentIndex: 0

            // Adicionar 10 opções ao ComboBox
            model: ListModel {
                ListElement {
                    text: "Amostragem Aleatória Simples"
                }
                ListElement {
                    text: "Amostragem Estratificada"
                }
                ListElement {
                    text: "Amostragem Sistemática"
                }
                ListElement {
                    text: "Amostragem em Dois Estágios"
                }
                ListElement {
                    text: "Amostragem em Conglomerados"
                }
                ListElement {
                    text: "Amostragem Sistemática com Múltiplos Inícios Aleatórios"
                }
                ListElement {
                    text: "Amostragem Independente"
                }
                ListElement {
                    text: "Amostragem com Repetição Total"
                }
                ListElement {
                    text: "Amostragem Dupla"
                }
                ListElement {
                    text: "Amostragem com Repetição Parcial"
                }
            }
            // Usar um ItemDelegate personalizado para centralizar o texto
            delegate: ItemDelegate {
                width: comboBox.width
                height: comboBox.height

                contentItem: Text {
                    text: model.text
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Button {
            text: qsTr("Iniciar Processamento")
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 50
            onClicked: {
                if (comboBox.currentIndex === 10) {
                    var aaswindow = Qt.createComponent("aas.qml")
                    if (aaswindow.status === Component.Ready) {
                        var aaswindowObject = aaswindow.createObject(parent);

                      // Mostre a nova janela
                        aaswindowObject.show();
                    } else {
                      console.error("Falha ao criar a nova janela:", aaswindow.errorString());
                    }
                } else if (comboBox.currentIndex === 1) {
                    var aewindow = Qt.createComponent("ae.qml")
                    if (aewindow.status === Component.Ready) {
                        var aewindowObject = aewindow.createObject(parent);

                      // Mostre a nova janela
                        aewindowObject.show();
                    } else {
                      console.error("Falha ao criar a nova janela:", aewindow.errorString());
                    }
                } else if (comboBox.currentIndex === 2) {
                    var aswindow = Qt.createComponent("as.qml")
                    if (aswindow.status === Component.Ready) {
                        var aswindowObject = aswindow.createObject(parent);

                      // Mostre a nova janela
                        aswindowObject.show();
                    } else {
                      console.error("Falha ao criar a nova janela:", aswindow.errorString());
                    }
                } else if (comboBox.currentIndex === 3) {
                    var adewindow = Qt.createComponent("ade.qml")
                    if (adewindow.status === Component.Ready) {
                        var adewindowObject = adewindow.createObject(parent);

                      // Mostre a nova janela
                        adewindowObject.show();
                    } else {
                      console.error("Falha ao criar a nova janela:", vpch2window.errorString());
                    }
                } else if (comboBox.currentIndex === 4) {
                    var acwindow = Qt.createComponent("ac.qml")
                    if (acwindow.status === Component.Ready) {
                        var acwindowObject = acwindow.createObject(parent);

                      // Mostre a nova janela
                        acwindowObject.show();
                    } else {
                      console.error("Falha ao criar a nova janela:", acwindow.errorString());
                    }
                } else if (comboBox.currentIndex === 5) {
                    var ascmiawindow = Qt.createComponent("ascmia.qml")
                    if (ascmiawindow.status === Component.Ready) {
                        var ascmiawindowObject = ascmiawindow.createObject(parent);

                      // Mostre a nova janela
                        ascmiawindowObject.show();
                    } else {
                      console.error("Falha ao criar a nova janela:", ascmiawindow.errorString());
                    }
                } else if (comboBox.currentIndex === 6) {
                    var aiwindow = Qt.createComponent("ai.qml")
                    if (aiwindow.status === Component.Ready) {
                        var aiwindowObject = aiwindow.createObject(parent);

                      // Mostre a nova janela
                        aiwindowObject.show();
                    } else {
                      console.error("Falha ao criar a nova janela:", aiwindow.errorString());
                    }
                } else if (comboBox.currentIndex === 7) {
                    var artwindow = Qt.createComponent("art.qml")
                    if (artwindow.status === Component.Ready) {
                        var artwindowObject = artwindow.createObject(parent);

                      // Mostre a nova janela
                        artwindowObject.show();
                    } else {
                      console.error("Falha ao criar a nova janela:", artwindow.errorString());
                    }
                } else if (comboBox.currentIndex === 8) {
                    var adwindow = Qt.createComponent("ad.qml")
                    if (adwindow.status === Component.Ready) {
                        var adwindowObject = adwindow.createObject(parent);

                      // Mostre a nova janela
                        adwindowObject.show();
                    } else {
                      console.error("Falha ao criar a nova janela:", adwindow.errorString());
                    }
                } else if (comboBox.currentIndex === 9) {
                    var arpwindow = Qt.createComponent("arp.qml")
                    if (arpwindow.status === Component.Ready) {
                        var arpwindowObject = arpwindow.createObject(parent);

                      // Mostre a nova janela
                        arpwindowObject.show();
                    } else {
                      console.error("Falha ao criar a nova janela:", arpwindow.errorString());
                    }
                } else {

                }
            }
        }
    }
}
