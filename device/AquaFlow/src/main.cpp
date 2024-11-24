#include <WiFi.h>

// Wi-Fi credentials for the Access Point
const char *ssid = "AquaFlow-ESP32";  // Name of the network
const char *password = "12345678";   // Password for the network (minimum 8 characters)

// Pin for the LED
const int ledPin = 2;  // Built-in LED on most ESP32 boards

void setup() {
  // Start Serial Monitor
  Serial.begin(115200);

  // Initialize the LED pin as output
  pinMode(ledPin, OUTPUT);

  // Initialize Wi-Fi in Access Point mode
  WiFi.softAP(ssid, password);

  // Get IP address of the ESP32 Access Point
  IPAddress IP = WiFi.softAPIP();
  Serial.print("ESP32 AP IP Address: ");
  Serial.println(IP);
}

void loop() {
  // Check the number of connected devices
  int numConnectedDevices = WiFi.softAPgetStationNum();

  if (numConnectedDevices > 0) {
    // If a device is connected, blink twice per second (500ms ON, 500ms OFF)
    digitalWrite(ledPin, HIGH);
    delay(2000);  // LED ON for 250ms
    digitalWrite(ledPin, LOW);
    delay(1000);  // LED OFF for 250ms
  } else {
    // If no devices are connected, blink once per second (1s ON, 1s OFF)
    digitalWrite(ledPin, HIGH);
    delay(1000);  // LED ON for 500ms
    digitalWrite(ledPin, LOW);
    delay(1000);  // LED OFF for 500ms
  }
}
