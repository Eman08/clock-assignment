import QtQuick

Window {
    width: 500
    height: 500
    visible: true
    title: "Clock"
    property int currentHour: 12
    property int currentMinute: 0
    property bool isAm: true
    property real dragMultiplier: 0.01 // Adjust this multiplier to control dragging speed

    function calculateHour() {
        var angle = (hourHand.rotation + 360) % 360;
        currentHour = Math.floor(angle / 30);

    }

    function calculateMinute() {
        var angle = (minuteHand.rotation + 360) % 360;
        currentMinute = Math.floor(angle / 6);
    }

    Item {
        width: 450
        height: 500

        Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
            border.color: "black"
            border.width: 1
            radius: 10

            // Draw hour markers
            Repeater {
                model: 12
                delegate: Text {
                    text: (index === 0 ? 12 : index).toString()
                    font.pixelSize: 16

                    // Calculate position around the clock
                    x: parent.width / 2 + (parent.width / 3) * Math.cos(-Math.PI / 6 * index + Math.PI / 2) - width / 2
                    y: parent.height / 2 - (parent.height / 3) * Math.sin(-Math.PI / 6 * index + Math.PI / 2) - height / 2
                }
            }
        }

        Rectangle {
            id: hourHand
            color: "black"
            width: 10
            height: parent.height / 5
            x: (parent.width / 2) - (width / 2)
            y: Math.abs(maxSize - height)
            transformOrigin: Item.Bottom

            property int maxSize: parent.height / 2
            property bool isDragging: false

            MouseArea {
                id: hourHandDragArea
                anchors.fill: parent

                onPressed: {
                    hourHand.isDragging = true;
                }

                onPositionChanged: {
                    if (hourHand.isDragging) {
                        var angle = Math.atan2(mouseY - parent.height / 2, mouseX - parent.width / 2) * 180 / Math.PI;
                        hourHand.rotation += (angle +360) * dragMultiplier;
                        calculateHour();
                    }
                }

                onReleased: {
                    hourHand.isDragging = false;
                }
            }
        }

        Rectangle {
            id: minuteHand
            color: "black"
            width: 6
            height: parent.height / 3.5
            x: (parent.width / 2) - (width / 2)
            y: Math.abs(maxSize - height)
            transformOrigin: Item.Bottom

            property int maxSize: parent.height / 2
            property bool isDragging: false

            MouseArea {
                id: minuteHandDragArea
                anchors.fill: parent

                onPressed: {
                    minuteHand.isDragging = true;
                }

                onPositionChanged: {
                    if (minuteHand.isDragging) {
                        var angle = Math.atan2(mouseY - parent.height / 2, mouseX - parent.width / 2) * 180 / Math.PI;
                        minuteHand.rotation += (angle + 360) * dragMultiplier;
                        calculateMinute();
                    }
                }

                onReleased: {
                    minuteHand.isDragging = false;
                }
            }
        }

        Rectangle {
            width: 100 // Adjust width as needed
            height: 40 // Adjust height as needed
            color: "lightgray" // Background color

            Text {
                text: (currentHour < 10 ? "0" + currentHour : currentHour) + ":" +
                      (currentMinute < 10 ? "0" + currentMinute : currentMinute)
                font.pixelSize: 20
                color: "black"
                anchors.centerIn: parent
            }
        }
    }
}
