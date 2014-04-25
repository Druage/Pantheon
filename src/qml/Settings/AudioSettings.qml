import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../js/parseBooleanStyle.js" as ParseBool
import "../../js/check.js" as Check

Rectangle {
    id: root
    property var cfg
   // property string backgroundStyle
    //property string fontColor
    //property var checkBoxStyle

   // color: backgroundStyle
    color: "#000000FF"
    ColumnLayout {
        anchors.centerIn: parent
        height: parent.height

        CheckBox {
            id: muteCheck
            text: "Enable Audio"
            checked: ParseBool.parse(cfg["audio_enable"])
            //style: checkBoxStyle
            onCheckedChanged: {
                cfg["audio_enable"] = Check.checked_is(checked);
            }
        }

        RowLayout {
            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: "Volume Level:"
                //color: fontColor
            }

            SpinBox {
                anchors.verticalCenter: parent.verticalCenter
                maximumValue: 12
                minimumValue: -80
                stepSize: 1
                value: parseInt(_cfg["audio_volume"])
                onValueChanged: {
                    cfg["audio_volume"] = value
                }
            }
        }

        GroupBox {
            height: 300
            title: "Rate Control"
            checkable: true
            checked: ParseBool.parse(cfg["audio_rate_control"])
            onCheckedChanged: {
                cfg["audio_rate_control"] = checked.toString()
            }
            RowLayout {
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Rate Control Delta:"
                   /// color: fontColor
                    }

                SpinBox {
                    id: rateControlSpin
                    anchors.verticalCenter: parent.verticalCenter
                    decimals: 3
                    maximumValue: 0.2
                    minimumValue: 0.0
                    stepSize: 0.001
                    value: parseFloat(_cfg["audio_rate_control_delta"])
                    onValueChanged: {
                        cfg["audio_rate_control_delta"] = value.toFixed(6)
                    }
                }

            }
        }

        RowLayout {
            Label {
                text: "Audio Rate:"
                //color: fontColor
            }
            SpinBox {
                value: parseInt(_cfg["audio_out_rate"])
                maximumValue: 48000
                minimumValue: 22050
                stepSize: 50
                onValueChanged: {
                    cfg["audio_out_rate"] = value
                }
            }
        }

        RowLayout {
            Label {
                text: "Driver:"
                //color: fontColor
            }
            ComboBox {
                id: audioCombo
                model: ["dsound", "rsound", "sdl", "xaudio"]
                currentIndex: check_driver(_cfg["audio_driver"])
                onCurrentTextChanged: {
                    cfg["audio_driver"] = currentText
                }
            }
        }
    }
}
