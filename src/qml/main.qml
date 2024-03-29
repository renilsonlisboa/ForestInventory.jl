import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Dialogs 6.5
import org.julialang

ApplicationWindow {
    id: mainAPP
    title: "Forest Inventory"
    width: 640
    height: 480
    x: (Screen.width - width)/2
    y: (Screen.height - height)/2
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height
    visible: true

    property var resultVals: []
    property string resultObs: ""
    property int subestratosOK: 0
    property bool verifySelected: false

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
            width: 500
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
            text: qsTr("Escolher Amostragem")
            width: 200
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 100

            Connections {
                target: processInvent
                onClicked: {
                    if (comboBox.currentIndex === 0) {
                        inventAAS.visible = true
                    } else if (comboBox.currentIndex === 1) {
                        inventESTRAT.visible = true
                    } else if (comboBox.currentIndex === 2) {
                        inventSIST.visible = true
                    } else if (comboBox.currentIndex === 3) {
                        inventDE.visible = true
                    } else if (comboBox.currentIndex === 4) {
                        inventCONGL.visible = true
                    } else if (comboBox.currentIndex === 5) {
                        inventMULTI.visible = true
                    } else if (comboBox.currentIndex === 6) {
                        inventIND.visible = true
                    } else if (comboBox.currentIndex === 7) {
                        inventART.visible = true
                    } else if (comboBox.currentIndex === 8) {
                        inventAD.visible = true
                    } else if (comboBox.currentIndex === 9) {
                        inventARP.visible = true
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

        //Amostragem Aleatória Simples
        Window {
            id: inventAAS
            title: "Amostragem Aleatória Simples"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            minimumWidth: width
            maximumWidth: width
            minimumHeight: height
            maximumHeight: height
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
                Button {
                    id: importDataAAS
                    text: qsTr("Importar Dados")
                    width: 300
                    font.family: "Arial"
                    font.pointSize: 14
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120

                    Connections {
                        target: importDataAAS
                        onClicked: {
                            selectedFileDialogAAS.open()
                        }
                    }
                }

                Image {
                    id: correctAAS
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
                    visible: false
                }

                Image {
                    id: errorAAS
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/error.png" // Substitua pelo caminho real da sua imagem
                    width: 40
                    height: 30
                    visible: false
                }

                Column {
                    id: columnsEnterAAS
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areainvAAS
                        placeholderText: "Área inventariada (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvAAS.text.includes(",")) {
                                    areainvAAS.text = areainvAAS.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areaparcAAS
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areaparcAAS.text.includes(",")) {
                                    areaparcAAS.text = areaparcAAS.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: earAAS
                        placeholderText: "Erro relativo admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (earAAS.text.includes(",")) {
                                    earAAS.text = earAAS.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: alphaAAS
                        placeholderText: "Alfa"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (alphaAAS.text.includes(",")) {
                                    alphaAAS.text = alphaAAS.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }

                    Button {
                        id: processInventAAS
                        text: qsTr("Processar Inventário")
                        width: 300
                        font.pointSize: 14
                        font.family: "Arial"

                        Connections {
                            target: processInventAAS
                            onClicked: {
                                var emptyFieldsAAS = []

                                // Verifique se os campos estão vazios ou contêm apenas espaços em branco
                                if (!areainvAAS.text || areainvAAS.text.trim() === "") {
                                    emptyFieldsAAS.push("Área Inventariada")
                                }

                                if (!areaparcAAS.text || areaparcAAS.text.trim() === "") {
                                    emptyFieldsAAS.push("Área da Parcela")
                                }

                                if (!earAAS.text || earAAS.text.trim() === "") {
                                    emptyFieldsAAS.push("EAR")
                                }

                                if (!alphaAAS.text || alphaAAS.text.trim() === "") {
                                    emptyFieldsAAS.push("Alpha")
                                }

                                if (emptyFieldsAAS.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogAAS.text = "Ausência de dados nos campos: " + emptyFieldsAAS.join(", ")
                                    emptyDialogAAS.open()
                                } else if (verifySelected === false) {
                                    emptySelectedDialogAAS.open()
                                } else {
                                    busyIndicatorAAS.running = true

                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcAAS(Julia.singleFile(selectedFileDialogAAS.currentFile), areainvAAS.text, areaparcAAS.text, alphaAAS.text, earAAS.text)

                                    resultVals = resultados[0]
                                    resultObs = resultados[1] + "\n\n" + resultados[2]

                                    saveFileDialogAAS.open()
                                }
                            }
                        }
                    }
                }
            }

            BusyIndicator {
                id: busyIndicatorAAS
                width: 120
                height: 120
                running: false
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 250
            }

            FileDialog {
                id: selectedFileDialogAAS
                title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                fileMode: FileDialog.OpenFile
                nameFilters: ["CSV Files (*.csv)"]
                Component.onCompleted: visible = false

                Connections {
                    target: selectedFileDialogAAS
                    onAccepted: {
                        correctAAS.visible = true
                        errorAAS.visible = false
                        verifySelected = true
                    }
                    onRejected: {
                        correctAAS.visible = false
                        errorAAS.visible = true
                        verifySelected = false 
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogAAS
                title: "Inventário Processado com Sucesso"
                text: resultObs
            }

            FileDialog {
                id: saveFileDialogAAS
                title: "Selecione o local para salvar o arquivo..."
                fileMode: FileDialog.SaveFile
                Connections {
                    target: saveFileDialogAAS
                    onAccepted: {
                        Julia.saveFile(resultVals, saveFileDialogAAS.selectedFile, comboBox.currentIndex)
                        conclusionDialogAAS.open()
                        busyIndicatorAAS.running = false
                    }
                    onRejected: {
                        busyIndicatorAAS.running = false
                    }
                }
            }

            MessageDialog {
                id: emptySelectedDialogAAS
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
                text: "Você deve selecionar um arquivo .CSV para prosseguir"
            }

            MessageDialog {
                id: emptyDialogAAS
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
            }

            Connections {
                target: inventAAS
                onClosing:{
                    areainvAAS.text = ""
                    areaparcAAS.text = ""
                    earAAS.text = ""
                    alphaAAS.text = ""
                    correctAAS.visible = false
                    errorAAS.visible = false
                    verifySelected = false
                }
            }
        }

        //Amostragem Estratificada
        Window {
            id: inventESTRAT
            title: "Amostragem Estratificada"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            minimumWidth: width
            maximumWidth: width
            minimumHeight: height
            maximumHeight: height
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


                Button {
                    id: importDataESTRAT
                    text: qsTr("Importar Dados")
                    width: 380
                    font.family: "Arial"
                    font.pointSize: 14
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -125

                    Connections {
                        target: importDataESTRAT
                        onClicked: {
                            selectedFileDialogESTRAT.open()
                        }
                    }
                }

                Image {
                    id: correctESTRAT
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -125
                    anchors.horizontalCenterOffset: 220
                    source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
                    visible: false
                }

                Image {
                    id: errorESTRAT
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -125
                    anchors.horizontalCenterOffset: 220
                    source: "images/error.png" // Substitua pelo caminho real da sua imagem
                    width: 40
                    height: 30
                    visible: false
                }

                Column {
                    id: columnsEnterESTRAT
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areainvESTRAT
                        placeholderText: "Área inventariada (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 380
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvESTRAT.text.includes(",")) {
                                    areainvESTRAT.text = areainvESTRAT.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areaparcESTRAT
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 380
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areaparcESTRAT.text.includes(",")) {
                                    areaparcESTRAT.text = areaparcESTRAT.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: earESTRAT
                        placeholderText: "Erro relativo admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 380
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (earESTRAT.text.includes(",")) {
                                    earESTRAT.text = earESTRAT.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: alphaESTRAT
                        placeholderText: "Alfa"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 380
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (alphaESTRAT.text.includes(",")) {
                                    alphaESTRAT.text = alphaESTRAT.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }

                    Row {
                        spacing: 10
                        TextField {
                            id: estratosESTRAT
                            placeholderText: "1º Subestrato"
                            validator: IntValidator {}
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: 14
                            font.family: "Arial"
                            width: 120
                        }
                        TextField {
                            id: estratosESTRAT2
                            placeholderText: "2º Subestrato"
                            validator: IntValidator {}
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: 14
                            font.family: "Arial"
                            width: 120
                        }
                        TextField {
                            id: estratosESTRAT3
                            placeholderText: "3º Subestrato"
                            validator: IntValidator {}
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: 14
                            font.family: "Arial"
                            width: 120
                        }
                    }

                    Button {
                        id: processInventESTRAT
                        text: qsTr("Processar Inventário")
                        width: 380
                        font.pointSize: 14
                        font.family: "Arial"
                        anchors.verticalCenterOffset: 140

                        Connections {
                            target: processInventESTRAT
                            onClicked: {
                                var emptyFieldsESTRAT = []

                                // Verifique se os campos estão vazios ou contêm apenESTRAT espaços em branco
                                if (!areainvESTRAT.text || areainvESTRAT.text.trim() === "") {
                                    emptyFieldsESTRAT.push("Área Inventariada")
                                }

                                if (!areaparcESTRAT.text || areaparcESTRAT.text.trim() === "") {
                                    emptyFieldsESTRAT.push("Área da Parcela")
                                }

                                if (!earESTRAT.text || earESTRAT.text.trim() === "") {
                                    emptyFieldsESTRAT.push("EAR")
                                }

                                if (!alphaESTRAT.text || alphaESTRAT.text.trim() === "") {
                                    emptyFieldsESTRAT.push("Alpha")
                                }

                                if (emptyFieldsESTRAT.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogESTRAT.text = "Ausência de dados nos campos: "+ emptyFieldsESTRAT.join(", ")
                                    emptyDialogESTRAT.open()
                                } else if (verifySelected === false) {
                                    emptySelectedDialogESTRAT.open()
                                } else {
                                    busyIndicatorESTRAT.running = true

                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcESTRAT(Julia.singleFile(selectedFileDialogESTRAT.currentFile), areainvESTRAT.text, areaparcESTRAT.text, alphaESTRAT.text, earESTRAT.text, estratosESTRAT.text, estratosESTRAT2.text, estratosESTRAT3.text)

                                    resultVals = resultados[0]
                                    resultObs = resultados[1] + "\n\n" + resultados[2]

                                    saveFileDialogESTRAT.open()
                                }
                            }
                        }
                    }
                }
            
                BusyIndicator {
                    id: busyIndicatorESTRAT
                    width: 120
                    height: 120
                    running: false
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 250
                }

                FileDialog {
                    id: selectedFileDialogESTRAT
                    title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                    fileMode: FileDialog.OpenFile
                    nameFilters: ["CSV Files (*.csv)"]
                    Component.onCompleted: visible = false

                    Connections {
                        target: selectedFileDialogESTRAT
                        onAccepted: {
                            correctESTRAT.visible = true
                            errorESTRAT.visible = false
                            verifySelected = true
                        }

                        onRejected: {
                            correctESTRAT.visible = false
                            errorESTRAT.visible = true
                            verifySelected = false
                        }
                    }
                }

                MessageDialog {
                    id: conclusionDialogESTRAT
                    title: "Inventário Processado com Sucesso"
                    text: resultObs
                }
                FileDialog {
                    id: saveFileDialogESTRAT
                    title: "Selecione o local para salvar o arquivo..."
                    fileMode: FileDialog.SaveFile

                    Connections {
                        target: saveFileDialogESTRAT
                        onAccepted: {
                            Julia.saveFile(resultVals, saveFileDialogESTRAT.selectedFile, comboBox.currentIndex)
                            conclusionDialogESTRAT.open()
                            busyIndicatorESTRAT.running = false
                        }
                        onRejected: {
                            busyIndicatorESTRAT.running = false
                        }
                    }
                }
                MessageDialog {
                    id: emptyDialogESTRAT
                    title: "Dados insuficientes para o processamento do inventário"
                    buttons: MessageDialog.Ok
                }
                MessageDialog {
                    id: emptySelectedDialogESTRAT
                    title: "Dados insuficientes para o processamento do inventário"
                    buttons: MessageDialog.Ok
                    text: "Você deve selecionar um arquivo .CSV para prosseguir"
                }

                Connections {
                    target: inventESTRAT
                    onClosing:{
                        areainvESTRAT.text = ""
                        areaparcESTRAT.text = ""
                        earESTRAT.text = ""
                        alphaESTRAT.text = ""
                        estratosESTRAT.text = ""
                        estratosESTRAT2.text = ""
                        estratosESTRAT3.text = ""
                        correctESTRAT.visible = false
                        errorESTRAT.visible = false
                        verifySelected = false
                    }
                }
            }
        }

        //Amostragem Sistematica
        Window {
            id: inventSIST
            title: "Amostragem Sistemática"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            minimumWidth: width
            maximumWidth: width
            minimumHeight: height
            maximumHeight: height
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

                Button {
                    id: importDataSIST
                    text: qsTr("Importar Dados")
                    width: 300
                    font.family: "Arial"
                    font.pointSize: 14
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120

                    Connections {
                        target: importDataSIST
                        onClicked: {
                            selectedFileDialogSIST.open()
                        }
                    }
                }

                Image {
                    id: correctSIST
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
                    visible: false
                }

                Image {
                    id: errorSIST
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/error.png" // Substitua pelo caminho real da sua imagem
                    width: 40
                    height: 30
                    visible: false
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
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }
                        
                        Connections {
                            onTextChanged: {
                                if (areainvSIST.text.includes(",")) {
                                    areainvSIST.text = areainvSIST.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areaparcSIST
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areaparcSIST.text.includes(",")) {
                                    areaparcSIST.text = areaparcSIST.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: earSIST
                        placeholderText: "Erro relativo admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (earSIST.text.includes(",")) {
                                    earSIST.text = earSIST.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: alphaSIST
                        placeholderText: "Alfa"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (alphaSIST.text.includes(",")) {
                                    alphaSIST.text = alphaSIST.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }

                    Button {
                        id: processInventSIST
                        text: qsTr("Processar Inventário")
                        width: 300
                        font.pointSize: 14
                        font.family: "Arial"
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
                                } else if (verifySelected === false) {
                                    emptySelectedDialogSIST.open()
                                } else {
                                    busyIndicatorSIST.running = true

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

            BusyIndicator {
                id: busyIndicatorSIST
                width: 120
                height: 120
                running: false
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 250
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
                        verifySelected = true
                    }

                    onRejected: {
                        errorSIST.visible = true
                        correctSIST.visible = false
                        verifySelected = false 
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
                        Julia.saveFile(resultVals, saveFileDialogSIST.selectedFile, comboBox.currentIndex)
                        conclusionDialogSIST.open()
                        busyIndicatorSIST.running = false
                    }
                    onRejected: {
                        busyIndicatorSIST.running = false
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

            Connections {
                target: inventSIST
                onClosing:{
                    areainvSIST.text = ""
                    areaparcSIST.text = ""
                    earSIST.text = ""
                    alphaSIST.text = ""
                    correctSIST.visible = false
                    errorSIST.visible = false
                    verifySelected = false
                }
            }  
        }

        //Amostragem em Dois Estágios
        Window {
            id: inventDE
            title: "Amostragem em Dois Estágios"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            minimumWidth: width
            maximumWidth: width
            minimumHeight: height
            maximumHeight: height
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

                Button {
                    id: importDataDE
                    text: qsTr("Importar Dados")
                    width: 400
                    font.family: "Arial"
                    font.pointSize: 14
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -130

                    Connections {
                        target: importDataDE
                        onClicked: {
                            selectedFileDialogDE.open()
                        }
                    }
                }

                Image {
                    id: correctDE
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -130
                    anchors.horizontalCenterOffset: 235
                    source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
                    visible: false
                }

                Image {
                    id: errorDE
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -130
                    anchors.horizontalCenterOffset: 235
                    source: "images/error.png" // Substitua pelo caminho real da sua imagem
                    width: 40
                    height: 30
                    visible: false
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
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvDE.text.includes(",")) {
                                    areainvDE.text = areainvDE.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areaparcDE
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 400
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areaparcDE.text.includes(",")) {
                                    areaparcDE.text = areaparcDE.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: potencialDE
                        placeholderText: "Número potencial de unidades secundárias"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 400
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (potencialDE.text.includes(",")) {
                                    potencialDE.text = potencialDE.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: earDE
                        placeholderText: "Erro relativo admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 400
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (earDE.text.includes(",")) {
                                    earDE.text = earDE.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: alphaDE
                        placeholderText: "Alfa"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 400
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (alphaDE.text.includes(",")) {
                                    alphaDE.text = alphaDE.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }

                    Button {
                        id: processInventDE
                        text: qsTr("Processar Inventário")
                        width: 400
                        font.pointSize: 14
                        font.family: "Arial"
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
                                } else if (verifySelected === false) {
                                    emptySelectedDialogDE.open()
                                } else {
                                    busyIndicatorDE.running = true
                                    
                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcDE(Julia.singleFile(selectedFileDialogDE.currentFile), areainvDE.text, areaparcDE.text, alphaDE.text, earDE.text, potencialDE.text)

                                    resultVals = resultados[0]
                                    resultObs = resultados[1] + "\n\n" + resultados[2]

                                    saveFileDialogDE.open()
                                }
                            }
                        }
                    }
                }
            }

            BusyIndicator {
                id: busyIndicatorDE
                width: 120
                height: 120
                running: false
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 250
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
                        verifySelected = true
                    }

                    onRejected: {
                        correctDE.visible = false
                        errorDE.visible = true
                        verifySelected = false
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
                        Julia.saveFile(resultVals, saveFileDialogDE.selectedFile, comboBox.currentIndex)
                        conclusionDialogDE.open()
                        busyIndicatorDE.running = false
                    }
                    onRejected: {
                        busyIndicatorDE.running = false
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
            Connections {
                target: inventDE
                onClosing:{
                    areainvDE.text = ""
                    areaparcDE.text = ""
                    earDE.text = ""
                    alphaDE.text = ""
                    potencialDE.text = ""
                    correctDE.visible = false
                    errorDE.visible = false
                    verifySelected = false
                }
            }
        }

        //Amostragem em Conglomerados
        Window {
            id: inventCONGL
            title: "Amostragem em Conglomerados"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            minimumWidth: width
            maximumWidth: width
            minimumHeight: height
            maximumHeight: height
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

                Button {
                    id: importDataCONGL
                    text: qsTr("Importar Dados")
                    width: 300
                    font.family: "Arial"
                    font.pointSize: 14
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120

                    Connections {
                        target: importDataCONGL
                        onClicked: {
                            selectedFileDialogCONGL.open()
                        }
                    }
                }

                Image {
                    id: correctCONGL
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
                    visible: false
                }

                Image {
                    id: errorCONGL
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/error.png" // Substitua pelo caminho real da sua imagem
                    width: 40
                    height: 30
                    visible: false
                }

                Column {
                    id: columnsEnterCONGL
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areainvCONGL
                        placeholderText: "Área inventariada (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvCONGL.text.includes(",")) {
                                    areainvCONGL.text = areainvCONGL.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areaparcCONGL
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areaparcCONGL.text.includes(",")) {
                                    areaparcCONGL.text = areaparcCONGL.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: earCONGL
                        placeholderText: "Erro relativo admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (earCONGL.text.includes(",")) {
                                    earCONGL.text = earCONGL.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: alphaCONGL
                        placeholderText: "Alfa"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (alphaCONGL.text.includes(",")) {
                                    alphaCONGL.text = alphaCONGL.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                
                    Button {
                        id: processInventCONGL
                        text: qsTr("Processar Inventário")
                        width: 300
                        font.pointSize: 14
                        font.family: "Arial"
                        anchors.verticalCenterOffset: 140

                        Connections {
                            target: processInventCONGL
                            onClicked: {
                                var emptyFieldsCONGL = []

                                // Verifique se os campos estão vazios ou contêm apenCONGL espaços em branco
                                if (!areainvCONGL.text || areainvCONGL.text.trim() === "") {
                                    emptyFieldsCONGL.push("Área Inventariada")
                                }

                                if (!areaparcCONGL.text || areaparcCONGL.text.trim() === "") {
                                    emptyFieldsCONGL.push("Área da Parcela")
                                }

                                if (!earCONGL.text || earCONGL.text.trim() === "") {
                                    emptyFieldsCONGL.push("EAR")
                                }

                                if (!alphaCONGL.text || alphaCONGL.text.trim() === "") {
                                    emptyFieldsCONGL.push("Alpha")
                                }

                                if (emptyFieldsCONGL.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogCONGL.text = "Ausência de dados nos campos: " + emptyFieldsCONGL.join(", ")
                                    emptyDialogCONGL.open()
                                } else if (verifySelected === false) {
                                    emptySelectedDialogCONGL.open()
                                } else {
                                    busyIndicatorCONGL.running = true                                    

                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcCONGL(Julia.singleFile(selectedFileDialogCONGL.currentFile), areainvCONGL.text, areaparcCONGL.text, alphaCONGL.text, earCONGL.text)

                                    resultVals = resultados[0]
                                    resultObs = resultados[1]

                                    saveFileDialogCONGL.open()
                                }
                            }
                        }
                    }
                }
            }

            BusyIndicator {
                id: busyIndicatorCONGL
                width: 120
                height: 120
                running: false
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 250
            }

            FileDialog {
                id: selectedFileDialogCONGL
                title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                fileMode: FileDialog.OpenFile
                nameFilters: ["CSV Files (*.csv)"]
                Component.onCompleted: visible = false

                Connections {
                    target: selectedFileDialogCONGL
                    onAccepted: {
                        correctCONGL.visible = true
                        errorCONGL.visible = false
                        verifySelected = true
                    }

                    onRejected: {
                        correctCONGL.visible = false
                        errorCONGL.visible = true
                        verifySelected = false 
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogCONGL
                title: "Inventário Processado com Sucesso"
                text: resultObs
            }
            FileDialog {
                id: saveFileDialogCONGL
                title: "Selecione o local para salvar o arquivo..."
                fileMode: FileDialog.SaveFile

                Connections {
                    target: saveFileDialogCONGL
                    onAccepted: {
                        Julia.saveFile(resultVals, saveFileDialogCONGL.selectedFile, comboBox.currentIndex)
                        conclusionDialogCONGL.open()
                        busyIndicatorCONGL.running = false
                    }
                    onRejected: {
                        busyIndicatorCONGL.running = false
                    }
                }
            }
            MessageDialog {
                id: emptyDialogCONGL
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
            }
            MessageDialog {
                id: emptySelectedDialogCONGL
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
                text: "Você deve selecionar um arquivo .CSV para prosseguir"
            }
            
            Connections {
                target: inventCONGL
                onClosing:{
                    areainvCONGL.text = ""
                    areaparcCONGL.text = ""
                    earCONGL.text = ""
                    alphaCONGL.text = ""
                    correctCONGL.visible = false
                    errorCONGL.visible = false
                    verifySelected = false
                }
            }
        }

        //Amostragem Sistemática com Multiplos Inícios Aleatórios
        Window {
            id: inventMULTI
            title: "Amostragem Sistemática com Multiplos Inícios Aleatórios"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            minimumWidth: width
            maximumWidth: width
            minimumHeight: height
            maximumHeight: height
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

                Button {
                    id: importDataMULTI
                    text: qsTr("Importar Dados")
                    width: 300
                    font.family: "Arial"
                    font.pointSize: 14
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120

                    Connections {
                        target: importDataMULTI
                        onClicked: {
                            selectedFileDialogMULTI.open()
                        }
                    }
                }

                Image {
                    id: correctMULTI
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
                    visible: false
                }

                Image {
                    id: errorMULTI
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/error.png" // Substitua pelo caminho real da sua imagem
                    width: 40
                    height: 30
                    visible: false
                }

                Column {
                    id: columnsEnterMULTI
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areainvMULTI
                        placeholderText: "Área inventariada (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvMULTI.text.includes(",")) {
                                    areainvMULTI.text = areainvMULTI.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areaparcMULTI
                        placeholderText: "Área da parcela (m²)"
                          horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areaparcMULTI.text.includes(",")) {
                                    areaparcMULTI.text = areaparcMULTI.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: earMULTI
                        placeholderText: "Erro Relativo Admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (earMULTI.text.includes(",")) {
                                    earMULTI.text = earMULTI.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: alphaMULTI
                        placeholderText: "Alfa"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (alphaMULTI.text.includes(",")) {
                                    alphaMULTI.text = alphaMULTI.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }

                    Button {
                        id: processInventMULTI
                        text: qsTr("Processar Inventário")
                        width: 300
                        font.pointSize: 14
                        font.family: "Arial"
                        anchors.verticalCenterOffset: 140

                        Connections {
                            target: processInventMULTI
                            onClicked: {
                                var emptyFieldsMULTI = []

                                // Verifique se os campos estão vazios ou contêm apenMULTI espaços em branco
                                if (!areainvMULTI.text || areainvMULTI.text.trim() === "") {
                                    emptyFieldsMULTI.push("Área Inventariada")
                                }

                                if (!areaparcMULTI.text || areaparcMULTI.text.trim() === "") {
                                    emptyFieldsMULTI.push("Área da Parcela")
                                }

                                if (!earMULTI.text || earMULTI.text.trim() === "") {
                                    emptyFieldsMULTI.push("EAR")
                                }

                                if (!alphaMULTI.text || alphaMULTI.text.trim() === "") {
                                    emptyFieldsMULTI.push("Alpha")
                                }

                                if (emptyFieldsMULTI.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogMULTI.text = "Ausência de dados nos campos: " + emptyFieldsMULTI.join(", ")
                                    emptyDialogMULTI.open()
                                } else if (verifySelected === false) {
                                    emptySelectedDialogMULTI.open()
                                } else {
                                    busyIndicatorMULTI.running = true

                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcMULTI(Julia.singleFile(selectedFileDialogMULTI.currentFile), areainvMULTI.text, areaparcMULTI.text, alphaMULTI.text, earMULTI.text)

                                    resultVals = resultados[0]
                                    resultObs = resultados[1]

                                    saveFileDialogMULTI.open()
                                }
                            }
                        }
                    }
                }
            }

            BusyIndicator {
                id: busyIndicatorMULTI
                width: 120
                height: 120
                running: false
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 250
            }

            FileDialog {
                id: selectedFileDialogMULTI
                title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                fileMode: FileDialog.OpenFile
                nameFilters: ["CSV Files (*.csv)"]
                Component.onCompleted: visible = false

                Connections {
                    target: selectedFileDialogMULTI
                    onAccepted: {
                        correctMULTI.visible = true
                        errorMULTI.visible = false
                        verifySelected = true
                    }

                    onRejected: {
                        correctMULTI.visible = false
                        errorMULTI.visible = true
                        verifySelected = false
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogMULTI
                title: "Inventário Processado com Sucesso"
                text: resultObs
            }
            FileDialog {
                id: saveFileDialogMULTI
                title: "Selecione o local para salvar o arquivo..."
                fileMode: FileDialog.SaveFile

                Connections {
                    target: saveFileDialogMULTI
                    onAccepted: {
                        Julia.saveFile(resultVals, saveFileDialogMULTI.selectedFile, comboBox.currentIndex)
                        conclusionDialogMULTI.open()
                        busyIndicatorMULTI.running = false
                    }
                    onRejected: {
                        busyIndicatorMULTI.running = false
                    }
                }
            }
            MessageDialog {
                id: emptyDialogMULTI
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
            }
            MessageDialog {
                id: emptySelectedDialogMULTI
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
                text: "Você deve selecionar um arquivo .CSV para prosseguir"
            }
            Connections {
                target: inventMULTI
                onClosing:{
                    areainvMULTI.text = ""
                    areaparcMULTI.text = ""
                    earMULTI.text = ""
                    alphaMULTI.text = ""
                    correctMULTI.visible = false
                    errorMULTI.visible = false
                    verifySelected = false
                }
            }
        }
        
        // Amostragem Independente
        Window {
            id: inventIND
            title: "Amostragem Independente"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            minimumWidth: width
            maximumWidth: width
            minimumHeight: height
            maximumHeight: height
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

                Button {
                    id: importDataIND
                    text: qsTr("Importar Dados")
                    width: 320
                    font.family: "Arial"
                    font.pointSize: 14
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120

                    Connections {
                        target: importDataIND
                        onClicked: {
                            selectedFileDialogIND.open()
                        }
                    }
                }

                Image {
                    id: correctIND
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
                    visible: false
                }

                Image {
                    id: errorIND
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/error.png" // Substitua pelo caminho real da sua imagem
                    width: 40
                    height: 30
                    visible: false
                }

                Column {
                    id: columnsEnterIND
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areaparcIND
                        placeholderText: "Área da Parcela (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 320
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areaparcIND.text.includes(",")) {
                                    areaparcIND.text = areaparcIND.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areainvOc1IND
                        placeholderText: "Área inventáriada na ocasião 1 (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 320
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvOc1IND.text.includes(",")) {
                                    areainvOc1IND.text = areainvOc1IND.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areainvOc2IND
                        placeholderText: "Área inventáriada na ocasião 2 (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 320
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvOc2IND.text.includes(",")) {
                                    areainvOc2IND.text = areainvOc2IND.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: alphaIND
                        placeholderText: "Alfa"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 320
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (alphaIND.text.includes(",")) {
                                    alphaIND.text = alphaIND.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }

                    Button {
                        id: processInventIND
                        text: qsTr("Processar Inventário")
                        width: 320
                        font.pointSize: 14
                        font.family: "Arial"

                        Connections {
                            target: processInventIND
                            onClicked: {
                                var emptyFieldsIND = []

                                // Verifique se os campos estão vazios ou contêm apenas espaços em branco
                                if (!areaparcIND.text || areaparcIND.text.trim() === "") {
                                    emptyFieldsIND.push("Área da Parcela")
                                }

                                if (!areainvOc1IND.text || areainvOc1IND.text.trim() === "") {
                                    emptyFieldsIND.push("Área Inventáriada na Ocasião 1")
                                }

                                if (!areainvOc2IND.text || areainvOc2IND.text.trim() === "") {
                                    emptyFieldsIND.push("Área Inventariada na Ocasião 2")
                                }

                                if (!alphaIND.text || alphaIND.text.trim() === "") {
                                    emptyFieldsIND.push("Alpha")
                                }

                                if (emptyFieldsIND.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogIND.text = "Ausência de dados nos campos: " + emptyFieldsIND.join(", ")
                                    emptyDialogIND.open()
                                } else if (verifySelected === false) {
                                    emptySelectedDialogIND.open()
                                } else {

                                    busyIndicatorIND.running = true

                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcIND(Julia.singleFile(selectedFileDialogIND.currentFile), areaparcIND.text, areainvOc1IND.text, areainvOc2IND.text, alphaIND.text)

                                    resultVals = resultados[0]

                                    saveFileDialogIND.open()
                                }
                            }
                        }
                    }
                }
            }

            BusyIndicator {
                id: busyIndicatorIND
                width: 120
                height: 120
                running: false
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 250
            }

            FileDialog {
                id: selectedFileDialogIND
                title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                fileMode: FileDialog.OpenFile
                nameFilters: ["CSV Files (*.csv)"]
                Component.onCompleted: visible = false

                Connections {
                    target: selectedFileDialogIND
                    onAccepted: {
                        correctIND.visible = true
                        errorIND.visible = false
                        verifySelected = true
                    }
                    onRejected: {
                        correctIND.visible = false
                        errorIND.visible = true
                        verifySelected = false 
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogIND
                title: "Inventário Processado com Sucesso"
                text: "O inventário foi processado com sucesso, o arquivo de resultado está disponível em: \n\n" + saveFileDialogIND.selectedFile
            }

            FileDialog {
                id: saveFileDialogIND
                title: "Selecione o local para salvar o arquivo..."
                fileMode: FileDialog.SaveFile
                Connections {
                    target: saveFileDialogIND
                    onAccepted: {
                        Julia.saveFile(resultVals, saveFileDialogIND.selectedFile, comboBox.currentIndex)
                        conclusionDialogIND.open()
                        busyIndicatorIND.running = false
                    }
                    onRejected: {
                        busyIndicatorIND.running = false
                    }
                }
            }

            MessageDialog {
                id: emptySelectedDialogIND
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
                text: "Você deve selecionar um arquivo .CSV para prosseguir"
            }

            MessageDialog {
                id: emptyDialogIND
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
            }

            Connections {
                target: inventIND
                onClosing:{
                    areaparcIND.text = ""
                    areainvOc1IND.text = ""
                    areainvOc2IND.text = ""
                    alphaIND.text = ""
                    correctIND.visible = false
                    errorIND.visible = false
                    verifySelected = false
                }
            }
        }

        // Amostragem com Repetição Total
        Window {
            id: inventART
            title: "Amostragem com Repetição Total"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            minimumWidth: width
            maximumWidth: width
            minimumHeight: height
            maximumHeight: height
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

                Button {
                    id: importDataART
                    text: qsTr("Importar Dados")
                    width: 320
                    font.family: "Arial"
                    font.pointSize: 14
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120

                    Connections {
                        target: importDataART
                        onClicked: {
                            selectedFileDialogART.open()
                        }
                    }
                }

                Image {
                    id: correctART
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
                    visible: false
                }

                Image {
                    id: errorART
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/error.png" // Substitua pelo caminho real da sua imagem
                    width: 40
                    height: 30
                    visible: false
                }

                Column {
                    id: columnsEnterART
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areaparcART
                        placeholderText: "Área da Parcela (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 320
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areaparcART.text.includes(",")) {
                                    areaparcART.text = areaparcART.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areainvOc1ART
                        placeholderText: "Área inventáriada na ocasião 1 (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 320
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvOc1ART.text.includes(",")) {
                                    areainvOc1ART.text = areainvOc1ART.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areainvOc2ART
                        placeholderText: "Área inventáriada na ocasião 2 (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 320
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvOc2ART.text.includes(",")) {
                                    areainvOc2ART.text = areainvOc2ART.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: alphaART
                        placeholderText: "Alfa"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 320
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (alphaART.text.includes(",")) {
                                    alphaART.text = alphaART.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }

                    Button {
                        id: processInventART
                        text: qsTr("Processar Inventário")
                        width: 320
                        font.pointSize: 14
                        font.family: "Arial"

                        Connections {
                            target: processInventART
                            onClicked: {
                                var emptyFieldsART = []

                                // Verifique se os campos estão vazios ou contêm apenas espaços em branco
                                if (!areaparcART.text || areaparcART.text.trim() === "") {
                                    emptyFieldsART.push("Área da Parcela")
                                }

                                if (!areainvOc1ART.text || areainvOc1ART.text.trim() === "") {
                                    emptyFieldsART.push("Área inventáriada na ocasião 1")
                                }

                                if (!areainvOc2ART.text || areainvOc2ART.text.trim() === "") {
                                    emptyFieldsART.push("Área inventariada na ocasião 2")
                                }

                                if (!alphaART.text || alphaART.text.trim() === "") {
                                    emptyFieldsART.push("Alfa")
                                }

                                if (emptyFieldsART.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogART.text = "Ausência de dados nos campos: " + emptyFieldsART.join(", ")
                                    emptyDialogART.open()
                                } else if (verifySelected === false) {
                                    emptySelectedDialogART.open()
                                } else {

                                    busyIndicatorART.running = true

                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcART(Julia.singleFile(selectedFileDialogART.currentFile), areaparcART.text, areainvOc1ART.text, areainvOc2ART.text, alphaART.text)

                                    resultVals = resultados[0]
                                    
                                    saveFileDialogART.open()
                                }
                            }
                        }
                    }
                }
            }

            BusyIndicator {
                id: busyIndicatorART
                width: 120
                height: 120
                running: false
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 250
            }

            FileDialog {
                id: selectedFileDialogART
                title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                fileMode: FileDialog.OpenFile
                nameFilters: ["CSV Files (*.csv)"]
                Component.onCompleted: visible = false

                Connections {
                    target: selectedFileDialogART
                    onAccepted: {
                        correctART.visible = true
                        errorART.visible = false
                        verifySelected = true
                    }
                    onRejected: {
                        correctART.visible = false
                        errorART.visible = true
                        verifySelected = false 
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogART
                title: "Inventário Processado com Sucesso"
                text: "O inventário foi processado com sucesso, o arquivo de resultado está disponível em: \n\n" + saveFileDialogART.selectedFile
            }

            FileDialog {
                id: saveFileDialogART
                title: "Selecione o local para salvar o arquivo..."
                fileMode: FileDialog.SaveFile
                Connections {
                    target: saveFileDialogART
                    onAccepted: {
                        Julia.saveFile(resultVals, saveFileDialogART.selectedFile, comboBox.currentIndex)
                        conclusionDialogART.open()
                        busyIndicatorART.running = false
                    }
                    onRejected: {
                        busyIndicatorART.running = false
                    }
                }
            }

            MessageDialog {
                id: emptySelectedDialogART
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
                text: "Você deve selecionar um arquivo .CSV para prosseguir"
            }

            MessageDialog {
                id: emptyDialogART
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
            }

            Connections {
                target: inventART
                onClosing:{
                    areaparcART.text = ""
                    areainvOc1ART.text = ""
                    areainvOc2ART.text = ""
                    alphaART.text = ""
                    correctART.visible = false
                    errorART.visible = false
                    verifySelected = false
                }
            }
        }

        // Amostragem Dupla
        Window {
            id: inventAD
            title: "Amostragem Dupla"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            minimumWidth: width
            maximumWidth: width
            minimumHeight: height
            maximumHeight: height
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

                Button {
                    id: importDataAD
                    text: qsTr("Importar Dados")
                    width: 300
                    font.family: "Arial"
                    font.pointSize: 14
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120

                    Connections {
                        target: importDataAD
                        onClicked: {
                            selectedFileDialogAD.open()
                        }
                    }
                }

                Image {
                    id: correctAD
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
                    visible: false
                }

                Image {
                    id: errorAD
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/error.png" // Substitua pelo caminho real da sua imagem
                    width: 40
                    height: 30
                    visible: false
                }

                Column {
                    id: columnsEnterAD
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areaparcAD
                        placeholderText: "Área da Parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areaparcAD.text.includes(",")) {
                                    areaparcAD.text = areaparcAD.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areainvAD
                        placeholderText: "Área da população (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvAD.text.includes(",")) {
                                    areainvAD.text = areainvAD.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: alphaAD
                        placeholderText: "Alfa"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (alphaAD.text.includes(",")) {
                                    alphaAD.text = alphaAD.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }

                    Button {
                        id: processInventAD
                        text: qsTr("Processar Inventário")
                        width: 300
                        font.pointSize: 14
                        font.family: "Arial"

                        Connections {
                            target: processInventAD
                            onClicked: {
                                var emptyFieldsAD = []

                                // Verifique se os campos estão vazios ou contêm apenas espaços em branco
                                if (!areaparcAD.text || areaparcAD.text.trim() === "") {
                                    emptyFieldsAD.push("Área da Parcela")
                                }

                                if (!areainvAD.text || areainvAD.text.trim() === "") {
                                    emptyFieldsAD.push("Área da População (ha)")
                                }

                                if (!alphaAD.text || alphaAD.text.trim() === "") {
                                    emptyFieldsAD.push("Alpha")
                                }

                                if (emptyFieldsAD.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogAD.text = "Ausência de dados nos campos: " + emptyFieldsAD.join(", ")
                                    emptyDialogAD.open()
                                } else if (verifySelected === false) {
                                    emptySelectedDialogAD.open()
                                } else {

                                    busyIndicatorAD.running = true

                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcAD(Julia.singleFile(selectedFileDialogAD.currentFile), areaparcAD.text, areainvAD.text, alphaAD.text)

                                    resultVals = resultados[0]
                                    
                                    saveFileDialogAD.open()
                                }
                            }
                        }
                    }
                }
            }

            BusyIndicator {
                id: busyIndicatorAD
                width: 120
                height: 120
                running: false
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 250
            }

            FileDialog {
                id: selectedFileDialogAD
                title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                fileMode: FileDialog.OpenFile
                nameFilters: ["CSV Files (*.csv)"]
                Component.onCompleted: visible = false

                Connections {
                    target: selectedFileDialogAD
                    onAccepted: {
                        correctAD.visible = true
                        errorAD.visible = false
                        verifySelected = true
                    }
                    onRejected: {
                        correctAD.visible = false
                        errorAD.visible = true
                        verifySelected = false 
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogAD
                title: "Inventário Processado com Sucesso"
                text: "O inventário foi processado com sucesso, o arquivo de resultado está disponível em: \n\n" + saveFileDialogAD.selectedFile
            }

            FileDialog {
                id: saveFileDialogAD
                title: "Selecione o local para salvar o arquivo..."
                fileMode: FileDialog.SaveFile
                Connections {
                    target: saveFileDialogAD
                    onAccepted: {
                        Julia.saveFile(resultVals, saveFileDialogAD.selectedFile, comboBox.currentIndex)
                        conclusionDialogAD.open()
                        busyIndicatorAD.running = false
                    }
                    onRejected: {
                        busyIndicatorAD.running = false
                    }
                }
            }

            MessageDialog {
                id: emptySelectedDialogAD
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
                text: "Você deve selecionar um arquivo .CSV para prosseguir"
            }

            MessageDialog {
                id: emptyDialogAD
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
            }

            Connections {
                target: inventAD
                onClosing:{
                    areaparcAD.text = ""
                    areainvAD.text = ""
                    alphaAD.text = ""
                    correctAD.visible = false
                    errorAD.visible = false
                    verifySelected = false
                }
            }
        }

       // Amostragem com Repetição Parcial
        Window {
            id: inventARP
            title: "Amostragem com Repetição Parcial"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            minimumWidth: width
            maximumWidth: width
            minimumHeight: height
            maximumHeight: height
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

                Button {
                    id: importDataARP
                    text: qsTr("Importar Dados")
                    width: 300
                    font.family: "Arial"
                    font.pointSize: 14
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120

                    Connections {
                        target: importDataARP
                        onClicked: {
                            selectedFileDialogARP.open()
                        }
                    }
                }

                Image {
                    id: correctARP
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
                    visible: false
                }

                Image {
                    id: errorARP
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -120
                    anchors.horizontalCenterOffset: 185
                    source: "images/error.png" // Substitua pelo caminho real da sua imagem
                    width: 40
                    height: 30
                    visible: false
                }

                Column {
                    id: columnsEnterARP
                    spacing: 15
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 20

                    // Adicione 4 campos de entrada (TextField)
                    TextField {
                        id: areaparcARP
                        placeholderText: "Área da Parcela (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areaparcARP.text.includes(",")) {
                                    areaparcARP.text = areaparcARP.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: areainvARP
                        placeholderText: "Área da população (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (areainvARP.text.includes(",")) {
                                    areainvARP.text = areainvARP.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }
                    TextField {
                        id: alphaARP
                        placeholderText: "Alfa"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (alphaARP.text.includes(",")) {
                                    alphaARP.text = alphaARP.text.replace(/,/g, ".");
                                }
                            }
                        }
                    }

                    Button {
                        id: processInventARP
                        text: qsTr("Processar Inventário")
                        width: 300
                        font.pointSize: 14
                        font.family: "Arial"

                        Connections {
                            target: processInventARP
                            onClicked: {
                                var emptyFieldsARP = []

                                // Verifique se os campos estão vazios ou contêm apenas espaços em branco
                                if (!areaparcARP.text || areaparcARP.text.trim() === "") {
                                    emptyFieldsARP.push("Área da Parcela")
                                }

                                if (!areainvARP.text || areainvARP.text.trim() === "") {
                                    emptyFieldsARP.push("Área da População (ha)")
                                }

                                if (!alphaARP.text || alphaARP.text.trim() === "") {
                                    emptyFieldsARP.push("Alpha")
                                }

                                if (emptyFieldsARP.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogARP.text = "Ausência de dados nos campos: " + emptyFieldsARP.join(", ")
                                    emptyDialogARP.open()
                                } else if (verifySelected === false) {
                                    emptySelectedDialogARP.open()
                                } else {

                                    busyIndicatorARP.running = true

                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcARP(Julia.singleFile(selectedFileDialogARP.currentFile), areaparcARP.text, areainvARP.text, alphaARP.text)

                                    resultVals = resultados[0]
                                    
                                    saveFileDialogARP.open()
                                }
                            }
                        }
                    }
                }
            }

            BusyIndicator {
                id: busyIndicatorARP
                width: 120
                height: 120
                running: false
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 250
            }

            FileDialog {
                id: selectedFileDialogARP
                title: "Selecione o arquivo no formato .CSV com os dados a serem processados"
                fileMode: FileDialog.OpenFile
                nameFilters: ["CSV Files (*.csv)"]
                Component.onCompleted: visible = false

                Connections {
                    target: selectedFileDialogARP
                    onAccepted: {
                        correctARP.visible = true
                        errorARP.visible = false
                        verifySelected = true
                    }
                    onRejected: {
                        correctARP.visible = false
                        errorARP.visible = true
                        verifySelected = false 
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogARP
                title: "Inventário Processado com Sucesso"
                text: "O inventário foi processado com sucesso, o arquivo de resultado está disponível em: \n\n" + saveFileDialogARP.selectedFile
            }

            FileDialog {
                id: saveFileDialogARP
                title: "Selecione o local para salvar o arquivo..."
                fileMode: FileDialog.SaveFile
                Connections {
                    target: saveFileDialogARP
                    onAccepted: {
                        Julia.saveFile(resultVals, saveFileDialogARP.selectedFile, comboBox.currentIndex)
                        conclusionDialogARP.open()
                        busyIndicatorARP.running = false
                    }
                    onRejected: {
                        busyIndicatorARP.running = false
                    }
                }
            }

            MessageDialog {
                id: emptySelectedDialogARP
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
                text: "Você deve selecionar um arquivo .CSV para prosseguir"
            }

            MessageDialog {
                id: emptyDialogARP
                title: "Dados insuficientes para o processamento do inventário"
                buttons: MessageDialog.Ok
            }

            Connections {
                target: inventARP
                onClosing:{
                    areaparcARP.text = ""
                    areainvARP.text = ""
                    alphaARP.text = ""
                    correctARP.visible = false
                    errorARP.visible = false
                    verifySelected = false
                }
            }
        }
    }
}
