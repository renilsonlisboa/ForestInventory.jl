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

        iconSource: "images/wallpaper.jpg" // Replace with the path to your icon file
    

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

        Window {
            id: inventAAS
            title: "Amostragem Aleatória Simples"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
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
                    source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
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
                    }
                    TextField {
                        id: areaparcAAS
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: earAAS
                        placeholderText: "Erro Relativo Admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: alphaAAS
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
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
                    errorAAS.visible = true
                }
            }
        }

        // Até aqui funcionou 100%

        Window {
            id: inventESTRAT
            width: 760
            height: 480
            title: "Janela do Inventário Estratificado"
            visible: false
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
            
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
                    anchors.verticalCenterOffset: -200

                    Button {
                        id: importDataESTRAT
                        text: qsTr("Importar Dados")
                        width: 180
                        font.family: "Arial"
                        font.pointSize: 14

                        Connections {
                            target: importDataESTRAT
                            onClicked: {
                                selectedFileDialogESTRAT.open()
                            }
                        }
                    }

                    Image {
                        id: correctESTRAT
                        source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: false
                    }

                    Image {
                        id: errorESTRAT
                        source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: true
                    }
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
                        width: 300
                    }
                    TextField {
                        id: areaparcESTRAT
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: earESTRAT
                        placeholderText: "Erro Relativo Admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: alphaESTRAT
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: estratosESTRAT
                        placeholderText: "Número de Estratos"
                        validator: IntValidator {}
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300

                        Connections {
                            target: estratosESTRAT
                            onTextChanged: {
                                enterNumSubEstratos.visible = true
                            }
                        }
                    }

                    Button {
                        id: processInventESTRAT
                        text: qsTr("Processar Inventário")
                        width: 300
                        font.pointSize: 14
                        font.family: "Arial"
                        anchors.verticalCenterOffset: 140

                        Connections {
                            target: processInventESTRAT
                            onClicked: {
                                var emptyFieldsESTRAT = []

                                // Verifique se os campos estão vazios ou contêm apenESTRAT espaços em branco
                                if (!areainvESTRAT.text || areainvESTRAT.text.trim(
                                            ) === "") {
                                    emptyFieldsESTRAT.push("Área Inventariada")
                                }

                                if (!areaparcESTRAT.text || areaparcESTRAT.text.trim(
                                            ) === "") {
                                    emptyFieldsESTRAT.push("Área da Parcela")
                                }

                                if (!earESTRAT.text || earESTRAT.text.trim() === "") {
                                    emptyFieldsESTRAT.push("EAR")
                                }

                                if (!alphaESTRAT.text || alphaESTRAT.text.trim() === "") {
                                    emptyFieldsESTRAT.push("Alpha")
                                }

                                if (!estratosESTRAT.text || estratosESTRAT.text.trim(
                                            ) === "") {
                                    emptyFieldsESTRAT.push("Número de Estratos")
                                }

                                if (subestratosOK === 0) {
                                    emptyFieldsESTRAT.push("Número de Sub-Estratos")
                                }

                                if (emptyFieldsESTRAT.length > 0) {
                                    // Se houver campos vazios, exiba o diálogo
                                    emptyDialogESTRAT.text = "Ausência de dados nos campos: "
                                            + emptyFieldsESTRAT.join(", ")
                                    emptyDialogESTRAT.open()
                                } else if (errorESTRAT.visible === true) {
                                    emptySelectedDialogESTRAT.open()
                                } else {
                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcESTRAT(
                                                Julia.singleFile(
                                                    selectedFileDialogESTRAT.currentFile),
                                                areainvESTRAT.text, areaparcESTRAT.text,
                                                alphaESTRAT.text, earESTRAT.text)

                                    resultVals = resultados[0]
                                    resultObs = resultados[1] + "\n\n" + resultados[2]

                                    saveFileDialogESTRAT.open()
                                }
                            }
                        }

                        Button {
                            id: enterNumSubEstratos
                            text: qsTr("Sub-estratos")
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -55
                            anchors.horizontalCenterOffset: 230
                            visible: false

                            Connections {
                                target: enterNumSubEstratos
                                onClicked: {
                                    windowSubEstratos.visible = true
                                }
                            }
                        }
                    }
                }

                Window {
                    id: windowSubEstratos
                    width: 840
                    height: 640
                    visible: false
                    x: (Screen.width - width) / 2  // Centralizar horizontalmente
                    y: (Screen.height - height) / 2  // Centralizar verticalmente

                    Rectangle {
                        width: parent.width
                        height: parent.height

                        Image {
                            source: "images/wallpaper.jpg" // Substitua pelo caminho real da sua imagem
                            width: parent.width
                            height: parent.height
                            fillMode: Image.Stretch
                            visible: true
                        }

                        Grid {
                            id: gridLayout
                            anchors.centerIn: parent
                            spacing: 10

                            Repeater {
                                model: estratosESTRAT.text
                                TextField {
                                    placeholderText: "SubEstrato" + (index + 1)
                                    horizontalAlignment: Text.AlignHCenter
                                    validator: IntValidator {}
                                    width: 120
                                    height: 30
                                    font.family: "Arial"
                                    font.pointSize: 10
                                }
                            }
                        }

                        Button {
                            id: closeSubEstratos
                            width: 200
                            text: qsTr("Confirmar")
                            font.pointSize: 14
                            font.family: "Arial"
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: 200

                            Connections {
                                target: closeSubEstratos
                                onClicked: {
                                    var vector = [] // Criar vetor vazio
                                    var contNull = 0

                                    for (var i = 0; i < gridLayout.children.length; ++i) {
                                        var textField = gridLayout.children[i]

                                        if (textField.text === "") {
                                            contNull = contNull + 1
                                        } else {
                                            vector.push(textField.text) // Adicionar texto de cada campo ao vetor
                                        }
                                    }
                                    if (contNull === 0) {
                                        windowSubEstratos.close()
                                        subestratosOK = 1
                                    } else {
                                        emptySubEstratos.open()
                                        subestratosOK = 0
                                    }
                                }
                            }
                        }
                    }

                    MessageDialog {
                        id: emptySubEstratos
                        title: "Número de SubEstratos Insuficiente"
                        buttons: MessageDialog.Ok
                    }
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
                        }

                        onRejected: {
                            errorESTRAT.visible = true
                        }
                    }
                }

                MessageDialog {
                    id: conclusionDialogESTRAT
                    title: "Inventário Processado com Sucesso"
                    text: resultObs
                }
                MessageDialog {
                    id: emptySelectedFileDialogESTRAT
                    title: "Falha ao tentar processar inventário"
                    text: "Selecione um arquivo com dados válidos para continuar" + "\n"
                        + selectedFileDialogESTRAT.currentFile
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
            }
        }

        Window {
            id: inventSIST
            width: 760
            height: 480
            title: "Janela do Inventário Sistemático"
            visible: false
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente

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
                        Julia.saveFile(resultVals, saveFileDialogSIST.selectedFile, comboBox.currentIndex)
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
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente

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
                        Julia.saveFile(resultVals, saveFileDialogDE.selectedFile, comboBox.currentIndex)
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
            id: inventCONGL
            width: 760
            height: 480
            title: "Janela do Inventário Conglomerados"
            visible: false
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente

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
                        id: importDataCONGL
                        text: qsTr("Importar Dados")
                        width: 180
                        font.family: "Arial"
                        font.pointSize: 14

                        Connections {
                            target: importDataCONGL
                            onClicked: {
                                selectedFileDialogCONGL.open()
                            }
                        }
                    }

                    Image {
                        id: correctCONGL
                        source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: false
                    }

                    Image {
                        id: errorCONGL
                        source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: true
                    }
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
                    }
                    TextField {
                        id: areaparcCONGL
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: earCONGL
                        placeholderText: "Erro Relativo Admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: alphaCONGL
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
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
                                } else if (errorCONGL.visible === true) {
                                    emptySelectedDialogCONGL.open()
                                } else {
                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcCONGL(Julia.singleFile(selectedFileDialogCONGL.currentFile), areainvCONGL.text, areaparcCONGL.text, alphaCONGL.text, earCONGL.text)

                                    resultVals = resultados[0]
                                    resultObs = resultados[1] + "\n\n" + resultados[2]

                                    saveFileDialogCONGL.open()
                                }
                            }
                        }
                    }
                }
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
                    }

                    onRejected: {
                        errorCONGL.visible = true
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogCONGL
                title: "Inventário Processado com Sucesso"
                text: resultObs
            }
            MessageDialog {
                id: emptySelectedFileDialogCONGL
                title: "Falha ao tentar processar inventário"
                text: "Selecione um arquivo com dados válidos para continuar" + "\n"
                    + selectedFileDialogCONGL.currentFile
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
        }

        Window {
            id: inventMULTI
            width: 760
            height: 480
            title: "Janela do Inventário Sistemático Multiplos Inícios"
            visible: false
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente

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
                        id: importDataMULTI
                        text: qsTr("Importar Dados")
                        width: 180
                        font.family: "Arial"
                        font.pointSize: 14

                        Connections {
                            target: importDataMULTI
                            onClicked: {
                                selectedFileDialogMULTI.open()
                            }
                        }
                    }

                    Image {
                        id: correctMULTI
                        source: "images/correct.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: false
                    }

                    Image {
                        id: errorMULTI
                        source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                        width: 50
                        height: 40
                        visible: true
                    }
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
                    }
                    TextField {
                        id: areaparcMULTI
                        placeholderText: "Área da parcela (m²)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: earMULTI
                        placeholderText: "Erro Relativo Admitido (%)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: alphaMULTI
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
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
                                } else if (errorMULTI.visible === true) {
                                    emptySelectedDialogMULTI.open()
                                } else {
                                    // Aqui você pode adicionar a lógica para processar os dados inseridos
                                    var resultados = Julia.calcMULTI(Julia.singleFile(selectedFileDialogMULTI.currentFile), areainvMULTI.text, areaparcMULTI.text, alphaMULTI.text, earMULTI.text)

                                    resultVals = resultados[0]
                                    resultObs = resultados[1] + "\n\n" + resultados[2]

                                    saveFileDialogMULTI.open()
                                }
                            }
                        }
                    }
                }
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
                    }

                    onRejected: {
                        errorMULTI.visible = true
                    }
                }
            }

            MessageDialog {
                id: conclusionDialogMULTI
                title: "Inventário Processado com Sucesso"
                text: resultObs
            }
            MessageDialog {
                id: emptySelectedFileDialogMULTI
                title: "Falha ao tentar processar inventário"
                text: "Selecione um arquivo com dados válidos para continuar" + "\n"
                    + selectedFileDialogMULTI.currentFile
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
        }
        
        // Amostragem Independente
        Window {
            id: inventIND
            title: "Amostragem Independente"
            width: 760
            height: 640
            x: (Screen.width - width) / 2  // Centralizar horizontalmente
            y: (Screen.height - height) / 2  // Centralizar verticalmente
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
                    width: 300
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
                    source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
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
                        width: 300
                    }
                    TextField {
                        id: areainvOc1IND
                        placeholderText: "Área Inventáriada na Ocasião 1 (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: areainvOc2IND
                        placeholderText: "Área Inventáriada na Ocasião 1 (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: alphaIND
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }

                    Button {
                        id: processInventIND
                        text: qsTr("Processar Inventário")
                        width: 300
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
                text: "O inventário foi processado com sucesso, o arquivo de resultado está disponível em: \n" + saveFileDialogIND.selectedFile
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
                    correctIND.visible = false
                    errorIND.visible = true
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
                    width: 300
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
                    source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
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
                        width: 300
                    }
                    TextField {
                        id: areainvOc1ART
                        placeholderText: "Área Inventáriada na Ocasião 1 (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: areainvOc2ART
                        placeholderText: "Área Inventáriada na Ocasião 1 (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: alphaART
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }

                    Button {
                        id: processInventART
                        text: qsTr("Processar Inventário")
                        width: 300
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
                                    emptyFieldsART.push("Área Inventáriada na Ocasião 1")
                                }

                                if (!areainvOc2ART.text || areainvOc2ART.text.trim() === "") {
                                    emptyFieldsART.push("Área Inventariada na Ocasião 2")
                                }

                                if (!alphaART.text || alphaART.text.trim() === "") {
                                    emptyFieldsART.push("Alpha")
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
                text: "O inventário foi processado com sucesso, o arquivo de resultado está disponível em: \n" + saveFileDialogART.selectedFile
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
                    correctART.visible = false
                    errorART.visible = true
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
                    source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
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
                        placeholderText: "Área da Parcela (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: areainvAD
                        placeholderText: "Área da população (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: alphaAD
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
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
                text: "O inventário foi processado com sucesso, o arquivo de resultado está disponível em: \n" + saveFileDialogAD.selectedFile
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
                    correctAD.visible = false
                    errorAD.visible = true
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
                    source: "images/errado.png" // Substitua pelo caminho real da sua imagem
                    width: 50
                    height: 40
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
                    }
                    TextField {
                        id: areainvARP
                        placeholderText: "Área da população (ha)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
                    }
                    TextField {
                        id: alphaARP
                        placeholderText: "Alpha (0.01 à 0.99)"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        font.family: "Arial"
                        width: 300
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
                text: "O inventário foi processado com sucesso, o arquivo de resultado está disponível em: \n" + saveFileDialogARP.selectedFile
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
                    correctARP.visible = false
                    errorARP.visible = true
                }
            }
        }
    }
}
