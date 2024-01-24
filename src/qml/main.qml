import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Dialogs 6.5
import org.julialang

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "Forest Inventory"

    property var resultVals: []
    property string resultObs: ""
    property string resultPop: ""

    Rectangle {
        id: retangulo
        visible: true
        width: parent.width
        height: parent.height

        Image {
            id: backgroundImage
            source: "images/wallpaper.jpg"
            width: retangulo.width
            height: retangulo.height // Substitua pelo caminho real da sua imagem
            fillMode: Image.Stretch
        }

        ComboBox {
            id: comboBox
            anchors.centerIn: parent
            width: 480
            height: 30
            currentIndex: 0

            // Adicionar 10 opções ao ComboBox
            model: ListModel {
                id: model
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

            contentItem: Text {
                text: comboBox.currentText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 14
                font.family: "Arial"
            }

            delegate: ItemDelegate {
                width: comboBox.width
                height: comboBox.height

                contentItem: Text {
                    text: model.text
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 14
                    font.family: "Arial"
                    padding: 10
                }
            }
        }

        Button {
            id: processInvent
            text: qsTr("Processar Inventário")
            width: 200
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 100

            Connections {
                target: processInvent
                onClicked: {
                    if (comboBox.currentIndex === 0) {
                        inventAAS.visible = true
                    } else if (comboBox.currentIndex === 1) {
                        inventAES.visible = true
                    } else if (comboBox.currentIndex === 2) {
                        inventAS.visible = true
                    } else if (comboBox.currentIndex === 3) {
                        inventDE.visible = true
                    } else if (comboBox.currentIndex === 4) {
                        inventCON.visible = true
                    } else if (comboBox.currentIndex === 5) {
                        inventSMI.visible = true
                    } else if (comboBox.currentIndex === 6) {
                        inventIND.visible = true
                    } else if (comboBox.currentIndex === 7) {
                        inventRPT.visible = true
                    } else if (comboBox.currentIndex === 8) {
                        inventDP.visible = true
                    } else if (comboBox.currentIndex === 9) {
                        inventRP.visible = true
                    } else {
                        Qt.quit()
                    }
                }
            }

            contentItem: Text {
                text: processInvent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 14
                font.family: "Arial"
            }
        }

        Window {
            id: inventAAS
            title: "Amostragem Aleatória Simples"
            width: 760
            height: 640
            visible: false

            Rectangle {
                width: parent.width
                height: parent.height
                visible: true

                Image {
                    source: "images/wallpaper.jpg" // Substitua pelo caminho real da sua imagem
                    width: parent.width
                    height: parent.height
                    opacity: 0.8
                    fillMode: Image.Stretch
                }

                Row {
                    spacing: 10
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -140

                    Button {
                        id: importData
                        text: qsTr("Importar Dados")
                        width: 180
                        font.family: "Arial"
                        font.pointSize: 14

                        Connections {
                            target: importData
                            onClicked: {
                                busyIndicator.visible = true
                                selectedFileDialog.open()
                            }
                        }
                    }

                    Button {
                        id: viewData
                        text: qsTr("Ver Dados")
                        font.pointSize: 14
                        font.family: "Arial"
                    }
                }

                Column {
                    id: columnsEnter
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areainv
                        placeholderText: "Área inventariada (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: areaparc
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: ear
                        placeholderText: "Erro Relativo Admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: alpha
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                }

                Button {
                    id: processInventAAS
                    text: qsTr("Processar Inventário")
                    width: 300
                    font.pointSize: 14
                    font.family: "Arial"
                    anchors.centerIn: columnsEnter
                    anchors.verticalCenterOffset: 140

                    Connections {
                        target: processInventAAS
                        onClicked: {

                            var emptyFields = [];

                            // Verifique se os campos estão vazios ou contêm apenas espaços em branco
                            if (!areainv.text || areainv.text.trim() === "") {
                                emptyFields.push("Área Inventariada");
                            }

                            if (!areaparc.text || areaparc.text.trim() === "") {
                                emptyFields.push("Área da Parcela");
                            }

                            if (!ear.text || ear.text.trim() === "") {
                                emptyFields.push("EAR");
                            }

                            if (!alpha.text || alpha.text.trim() === "") {
                                emptyFields.push("Alpha");
                            }

                            if (emptyFields.length > 0) {
                                // Se houver campos vazios, exiba o diálogo
                                emptyDialog.text = "Ausência de dados nos campos: " + emptyFields.join(", ");
                                emptyDialog.open();
                            } else {
                                // Aqui você pode adicionar a lógica para processar os dados inseridos
                                var resultados = Julia.calcAAS(Julia.singleFile(selectedFileDialog.currentFile), areainv.text, areaparc.text, alpha.text, ear.text)

                                resultVals = resultados[0]
                                resultPop = resultados[1]
                                resultObs = resultados[2]

                                saveFileDialog.open()
                            }                    
                        }
                    }
                }

                BusyIndicator {
                    id: busyIndicator
                    width: 80
                    height: 80
                    visible: false
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 240
                }

                FileDialog {
                    id: selectedFileDialog
                    title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                    fileMode: FileDialog.OpenFile
                    nameFilters: ["CSV Files (*.csv)"]

                    Connections {
                        onAccepted: {
                            busyIndicator.visible = false
                        }
                    }
                    Component.onCompleted: visible = false
                }
            }
            MessageDialog {
                id: conclusionDialog
                title: "Inventário Processado com Sucesso"
                text: resultObs
            }
            MessageDialog {
                id: conclusionPopDialog
                title: "Inventário Processado com Sucesso"
                text: resultPop
            }
            FileDialog {
                id: saveFileDialog
                title: "Selecione o local para salvar o arquivo..."
                fileMode: FileDialog.SaveFile
                
                Connections {
                    target: saveFileDialog
                    onAccepted: {
                        Julia.saveFile(resultVals, saveFileDialog.selectedFile)
                        conclusionDialog.open()
                        conclusionPopDialog.open()
                    }            
                }
            }
            MessageDialog {
                id: emptyDialog
                title: "Dados insuficientes para Calibração"
                buttons: MessageDialog.Ok
            }
        }

        Window {
            id: inventAES
            width: 760
            height: 480
            title: "Janela do Inventário Estratificado"
            visible: false


            Rectangle {
                id: rectangleAES
                color: "red"
            }
        }

        Window {
            id: inventAS
            width: 760
            height: 480
            title: "Janela do Inventário Sistemático"
            visible: false

            Rectangle {
                id: rectangleAS
                color: "pink"
            }
        }
        Window {
            id: inventDE
            width: 760
            height: 480
            title: "Janela do Inventário Dois Estágios"
            visible: false

            Rectangle {
                id: rectangleDE
                color: "green"
            }
        }
        Window {
            id: inventCON
            width: 760
            height: 480
            title: "Janela do Inventário Conglomerados"
            visible: false

            Rectangle {
                id: rectangleCON
                color: "purple"
            }
        }
        Window {
            id: inventSMI
            width: 760
            height: 480
            title: "Janela do Inventário Sistemático Multiplos Inícios"
            visible: false

            Rectangle {
                id: rectangleSMI
                color: "brown"
            }
        }
        Window {
            id: inventIND
            width: 760
            height: 480
            title: "Janela do Inventário Independente"
            visible: false

            Rectangle {
                id: rectangleIND
                color: "yellow"
            }
        }
        Window {
            id: inventRPT
            width: 760
            height: 480
            title: "Janela do Inventário Estratificado"
            visible: false

            Rectangle {
                id: rectangleRPT
                color: "green"
            }
        }
        Window {
            id: inventDP
            width: 760
            height: 480
            title: "Janela do Inventário Dupla"
            visible: false

            Rectangle {
                id: rectangleDP
                color: "orange"
            }
        }
        Window {
            id: inventRP
            width: 760
            height: 480
            title: "Janela do Inventário Parcial"
            visible: false

            Rectangle {
                id: rectangleRP
                color: "black"
            }
        }
    }
}
