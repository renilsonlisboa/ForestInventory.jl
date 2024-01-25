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
                        inventSIST.visible = true
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
                    fillMode: Image.Stretch
                    visible: true
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
                                selectedFileDialog.open()
                            }
                        }
                    }

                    Image {
                        id: correct
                        source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: false
                    }

                    Image {
                        id: error
                        source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: true
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
                            var emptyFields = []

                            // Verifique se os campos estão vazios ou contêm apenas espaços em branco
                            if (!areainv.text || areainv.text.trim() === "") {
                                emptyFields.push("Área Inventariada")
                            }

                            if (!areaparc.text || areaparc.text.trim() === "") {
                                emptyFields.push("Área da Parcela")
                            }

                            if (!ear.text || ear.text.trim() === "") {
                                emptyFields.push("EAR")
                            }

                            if (!alpha.text || alpha.text.trim() === "") {
                                emptyFields.push("Alpha")
                            }

                            if (emptyFields.length > 0) {
                                // Se houver campos vazios, exiba o diálogo
                                emptyDialog.text = "Ausência de dados nos campos: " + emptyFields.join(
                                            ", ")
                                emptyDialog.open()
                            } else if (error.visible === true) {
                                emptySelectedDialog.open()
                            } else {
                                // Aqui você pode adicionar a lógica para processar os dados inseridos
                                var resultados = Julia.calcAAS(
                                            Julia.singleFile(
                                                selectedFileDialog.currentFile),
                                            areainv.text, areaparc.text,
                                            alpha.text, ear.text)

                                resultVals = resultados[0]
                                resultObs = resultados[1] + "\n\n" + resultados[2]

                                saveFileDialog.open()
                            }
                        }
                    }
                }
            }

            FileDialog {
                id: selectedFileDialog
                title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                fileMode: FileDialog.OpenFile
                nameFilters: ["CSV Files (*.csv)"]
                Component.onCompleted: visible = false

                Connections {
                    target: selectedFileDialog
                    onAccepted: {
                        correct.visible = true
                        error.visible = false
                    }

                    onRejected: {
                        error.visible = true
                    }
                }
            }

            MessageDialog {
                id: conclusionDialog
                title: "Inventário Processado com Sucesso"
                text: resultObs
            }
            MessageDialog {
                id: emptySelectedFileDialog
                title: "Falha ao tentar processar inventário"
                text: "Selecione um arquivo com dados válidos para continuar" + "\n"
                    + selectedFileDialog.currentFile
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
                    }
                }
            }
            MessageDialog {
                id: emptyDialog
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
            }
            MessageDialog {
                id: emptySelectedDialog
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
                text: "Você deve selecionar um arquivo .CSV para prosseguir"
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
            id: inventSIST
            width: 760
            height: 480
            title: "Janela do Inventário Sistemático"
            visible: false

            Rectangle {
                width: parent.width
                height: parent.height
                visible: true

                Image {
                    source: "images/wallpaper.jpg" // Substitua pelo caminho real da sua imagem
                    width: parent.width
                    height: parent.height
                    fillMode: Image.Stretch
                    visible: true
                }

                Row {
                    spacing: 10
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -140

                    Button {
                        id: importDataSIST
                        text: qsTr("Importar Dados")
                        width: 180
                        font.family: "Arial"
                        font.pointSize: 14

                        Connections {
                            target: importDataSIST
                            onClicked: {
                                selectedFileDialogSIST.open()
                            }
                        }
                    }

                    Image {
                        id: correctSIST
                        source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: false
                    }

                    Image {
                        id: errorSIST
                        source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: true
                    }
                }

                Column {
                    id: columnsEnterSIST
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areainvSIST
                        placeholderText: "Área inventariada (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: areaparcSIST
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: earSIST
                        placeholderText: "Erro Relativo Admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: alphaSIST
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                

                    Button {
                        id: processInventSIST
                        text: qsTr("Processar Inventário")
                        width: 300
                        font.pointSize: 14
                        font.family: "Arial"
                        anchors.centerIn: columnsEnter
                        anchors.verticalCenterOffset: 140

                        Connections {
                            target: processInventSIST
                            onClicked: {
                                var emptyFieldsSIST = []

                                // Verifique se os campos estão vazios ou contêm apenSIST espaços em branco
                                if (!areainvSIST.text || areainvSIST.text.trim() === "") {
                                    emptyFieldsSIST.push("Área Inventariada")
                                }

                                if (!areaparcSIST.text || areaparcSIST.text.trim() === "") {
                                    emptyFieldsSIST.push("Área da Parcela")
                                }

                                if (!earSIST.text || earSIST.text.trim() === "") {
                                    emptyFieldsSIST.push("EAR")
                                }

                                if (!alphaSIST.text || alphaSIST.text.trim() === "") {
                                    emptyFieldsSIST.push("Alpha")
                                }

                                if (emptyFieldsSIST.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogSIST.text = "Ausência de dados nos campos: " + emptyFieldsSIST.join(", ")
                                    emptyDialogSIST.open()
                                } else if (errorSIST.visible === true) {
                                    emptySelectedDialogSIST.open()
                                } else {
                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcSIST(Julia.singleFile(selectedFileDialogSIST.currentFile), areainvSIST.text, areaparcSIST.text, alphaSIST.text, earSIST.text)

                                    resultVals = resultados[0]
                                    resultObs = resultados[1] + "\n\n" + resultados[2]

                                    saveFileDialogSIST.open()
                                }
                            }
                        }
                    }
                }
            }

            FileDialog {
                id: selectedFileDialogSIST
                title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                fileMode: FileDialog.OpenFile
                nameFilters: ["CSV Files (*.csv)"]
                Component.onCompleted: visible = false

                Connections {
                    target: selectedFileDialogSIST
                    onAccepted: {
                        correctSIST.visible = true
                        errorSIST.visible = false
                    }

                    onRejected: {
                        errorSIST.visible = true
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogSIST
                title: "Inventário Processado com Sucesso"
                text: resultObs
            }
            MessageDialog {
                id: emptySelectedFileDialogSIST
                title: "Falha ao tentar processar inventário"
                text: "Selecione um arquivo com dados válidos para continuar" + "\n"
                    + selectedFileDialogSIST.currentFile
            }
            FileDialog {
                id: saveFileDialogSIST
                title: "Selecione o local para salvar o arquivo..."
                fileMode: FileDialog.SaveFile

                Connections {
                    target: saveFileDialogSIST
                    onAccepted: {
                        Julia.saveFile(resultVals, saveFileDialogSIST.selectedFile)
                        conclusionDialogSIST.open()
                    }
                }
            }
            MessageDialog {
                id: emptyDialogSIST
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
            }
            MessageDialog {
                id: emptySelectedDialogSIST
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
                text: "Você deve selecionar um arquivo .CSV para prosseguir"
            }
        }

        Window {
            id: inventDE
            width: 760
            height: 480
            title: "Janela do Inventário Dois Estágios"
            visible: false

            Rectangle {
                width: parent.width
                height: parent.height
                visible: true

                Image {
                    source: "images/wallpaper.jpg" // Substitua pelo caminho real da sua imagem
                    width: parent.width
                    height: parent.height
                    fillMode: Image.Stretch
                    visible: true
                }

                Row {
                    spacing: 10
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -180

                    Button {
                        id: importDataDE
                        text: qsTr("Importar Dados")
                        width: 250
                        font.family: "Arial"
                        font.pointSize: 14

                        Connections {
                            target: importDataDE
                            onClicked: {
                                selectedFileDialogDE.open()
                            }
                        }
                    }

                    Image {
                        id: correctDE
                        source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: false
                    }

                    Image {
                        id: errorDE
                        source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: true
                    }
                }

                Column {
                    id: columnsEnterDE
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areainvDE
                        placeholderText: "Área inventariada (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 400
                    }
                    TextField {
                        id: areaparcDE
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 400
                    }
                    TextField {
                        id: potencialDE
                        placeholderText: "Número Potencial de Unidades Secundárias"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 400
                    }
                    TextField {
                        id: earDE
                        placeholderText: "Erro Relativo Admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 400
                    }
                    TextField {
                        id: alphaDE
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 400
                    }

                    Button {
                        id: processInventDE
                        text: qsTr("Processar Inventário")
                        width: 400
                        font.pointSize: 14
                        font.family: "Arial"
                        anchors.centerIn: columnsEnter
                        anchors.verticalCenterOffset: 140

                        Connections {
                            target: processInventDE
                            onClicked: {
                                var emptyFieldsDE = []

                                // Verifique se os campos estão vazios ou contêm apenDE espaços em branco
                                if (!areainvDE.text || areainvDE.text.trim() === "") {
                                    emptyFieldsDE.push("Área Inventariada")
                                }

                                if (!areaparcDE.text || areaparcDE.text.trim() === "") {
                                    emptyFieldsDE.push("Área da Parcela")
                                }

                                if (!potencialDE.text || potencialDE.text.trim() === "") {
                                    emptyFieldsDE.push(
                                                "Número Potencial de Unidades Secundárias")
                                }

                                if (!earDE.text || earDE.text.trim() === "") {
                                    emptyFieldsDE.push("EAR")
                                }

                                if (!alphaDE.text || alphaDE.text.trim() === "") {
                                    emptyFieldsDE.push("Alpha")
                                }

                                if (emptyFieldsDE.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogDE.text = "Ausência de dados nos campos: " + emptyFieldsDE.join(
                                                ", ")
                                    emptyDialogDE.open()
                                } else if (errorDE.visible === true) {
                                    emptySelectedDialogDE.open()
                                } else {
                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcDE(
                                                Julia.singleFile(
                                                    selectedFileDialogDE.currentFile),
                                                areainvDE.text, areaparcDE.text,
                                                alphaDE.text, earDE.text, potencialDE.text)

                                    resultVals = resultados[0]
                                    resultObs = resultados[1] + "\n\n" + resultados[2]

                                    saveFileDialogDE.open()
                                }
                            }
                        }
                    }
                }
            }
            
            FileDialog {
                id: selectedFileDialogDE
                title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                fileMode: FileDialog.OpenFile
                nameFilters: ["CSV Files (*.csv)"]
                Component.onCompleted: visible = false

                Connections {
                    target: selectedFileDialogDE
                    onAccepted: {
                        correctDE.visible = true
                        errorDE.visible = false
                    }

                    onRejected: {
                        errorDE.visible = true
                        console.log("deu ruim")
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogDE
                title: "Inventário Processado com Sucesso"
                text: resultObs
            }

            FileDialog {
                id: saveFileDialogDE
                title: "Selecione o local para salvar o arquivo..."
                fileMode: FileDialog.SaveFile

                Connections {
                    target: saveFileDialogDE
                    onAccepted: {
                        Julia.saveFile(resultVals, saveFileDialogDE.selectedFile)
                        conclusionDialogDE.open()
                    }
                }
            }
            MessageDialog {
                id: emptyDialogDE
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
            }
            MessageDialog {
                id: emptySelectedDialogDE
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
                text: "Você deve selecionar um arquivo .CSV para prosseguir"
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
