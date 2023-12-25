/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Dialogs
import QtQuick.Window
import org.julialang

ApplicationWindow{
    width: 480
    height: 520
    title: "Amostragem Aleatória Simples"

    Rectangle {
        width: 480
        height: 520

        Image {
            id: backgroundImage
            source: "images/wallpaper.jpg" // Substitua pelo caminho real da sua imagem
            anchors.fill: parent
            fillMode: Image.Stretch
        }

        Text {
            text: qsTr("Selecione um arquivo .CSV com os dados a serem processados")
            anchors.verticalCenterOffset: -200
            anchors.centerIn: parent
        }

        Row {
            anchors.centerIn: parent

            Button {
                id: importdata
                width: 120
                anchors.verticalCenterOffset: -150
                anchors.horizontalCenterOffset: -60
                text: qsTr("Importar dados")
            }

            Button {
                id: view
                width: 120
                anchors.verticalCenterOffset: -150
                anchors.horizontalCenterOffset: 60
                text: qsTr("View")
            }
        }

        Grid {
            id: gridLayout
            columns: 1
            anchors.centerIn: parent
            spacing: 10

            // Adicione 3 campos de entrada (TextField)
            TextField {
                id: areainv
                placeholderText: "Informe a área inventariada (ha)"
                horizontalAlignment: Text.AlignHCenter
                width: 250
            }
            TextField {
                id: areaparc
                placeholderText: "Informe a área da parcela (m²)"
                horizontalAlignment: Text.AlignHCenter
                width: 250
            }
            TextField {
                id: ear
                placeholderText: "Informe o erro relativo admitido (%)"
                horizontalAlignment: Text.AlignHCenter
                width: 250
            }
            TextField {
                id: alpha
                placeholderText: "Informe o valor de Alpha (0.01 à 0.99)"
                horizontalAlignment: Text.AlignHCenter
                width: 250
            }
        }

        Button {
            id: execute
            width: 250
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 150
            text: qsTr("Processar Inventário")
            onClicked: {
                Julia.aasCalc(45.0, 450.0, 0.05, 10.0, 0.1, 10.0)
            }
        }
    }
}
