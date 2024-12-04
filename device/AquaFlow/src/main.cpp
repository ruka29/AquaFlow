#include <WiFi.h>
#include <Preferences.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include <WebSocketsClient.h>
#include <ArduinoJson.h>

// Access Point credentials
const char *apSSID = "AquaFlow-Tank-Controller";
const char *apPassword = "12345678";

// LED pin for status indication
const int ledPin = 2;
// Potentiometer Pin
const int potPin = 34;
// Valve pin
const int valvePin = 23;

// Tank configuration
const float tankHeight = 100.0;       // Total tank height in cm
const float capacity = 10.0;          // Tank capacity in liters
const float maxThreshold = 90.0;      // Maximum water level percentage
const float minThreshold = 20.0;      // Minimum water level percentage
float waterLevel  = 0.0;
float oldWaterLevel = 0.0;
bool valveState = false;

// Preferences to store Wi-Fi credentials
Preferences preferences;
WiFiClientSecure client;

// HTTP Server
WebServer server(80);

// Time tracking for the heartbeat
unsigned long lastHeartbeatTime = 0;
const unsigned long heartbeatInterval = 1000; // 1 minute (60,000 ms)

// Function prototypes
void handleConnectWiFi();
void connectToWiFi(String ssid, String password);
void turnOffAP();
void handleWiFiRetry();
String extractValue(String json, String key);
void sendHeartbeat();
void readWaterLevel();
void autoControlValve();
void manualValveControl();
void updateWaterLevel();

void setup() {
  Serial.begin(115200);

  // Initialize the LED pin
  pinMode(ledPin, OUTPUT);
  // Initialize potentiometer pin
  pinMode(potPin, INPUT);
  // Initialize the valve pin
  pinMode(valvePin, OUTPUT);

  // Initialize preferences
  preferences.begin("wifi-creds", true);
  String savedSSID = preferences.getString("SSID", "");
  String savedPassword = preferences.getString("password", "");
  preferences.end();

  if (savedSSID != "" && savedPassword != "") {
    // Attempt to connect to saved Wi-Fi credentials
    connectToWiFi(savedSSID, savedPassword);
  } else {
    // Start Access Point mode if no credentials are found
    Serial.println("No Wi-Fi credentials found. Starting in Access Point mode...");
    WiFi.softAP(apSSID, apPassword);

    // Print Access Point IP address
    IPAddress IP = WiFi.softAPIP();
    Serial.print("ESP32 AP IP Address: ");
    Serial.println(IP);

    // Setup HTTP endpoint for Wi-Fi configuration
    server.on("/connect-wifi", HTTP_POST, handleConnectWiFi);
    server.begin();
    Serial.println("HTTP server started. Waiting for Wi-Fi details...");
  }
}

void loop() {
  // Handle HTTP server requests in AP mode
  server.handleClient();

  // LED indication based on AP status
  if (WiFi.getMode() == WIFI_AP) {
    int numConnectedDevices = WiFi.softAPgetStationNum();

    if (numConnectedDevices > 0) {
      // Blink twice per second when a device is connected
      digitalWrite(ledPin, HIGH);
      delay(250);
      digitalWrite(ledPin, LOW);
      delay(250);
    } else {
      // Blink once per second when no devices are connected
      digitalWrite(ledPin, HIGH);
      delay(500);
      digitalWrite(ledPin, LOW);
      delay(500);
    }
  }

  // Send heartbeat every minute
  unsigned long currentTime = millis();
  if (currentTime - lastHeartbeatTime >= heartbeatInterval) {
    lastHeartbeatTime = currentTime;
    sendHeartbeat();
  }

  readWaterLevel();
  manualValveControl();
}

// Handle the "/connect-wifi" HTTP endpoint
void handleConnectWiFi() {
  if (server.method() == HTTP_POST && server.hasArg("plain")) {
    String body = server.arg("plain");
    Serial.println("Received JSON payload:");
    Serial.println(body);

    // Extract SSID, password, and JWT token from the JSON payload
    String ssid = extractValue(body, "SSID");
    String password = extractValue(body, "password");
    String jwtToken = extractValue(body, "token");

    if (ssid != "" && password != "" && jwtToken != "") {
      // Save Wi-Fi credentials
      preferences.begin("wifi-creds", false);
      preferences.putString("SSID", ssid);
      preferences.putString("password", password);
      preferences.end();

      Serial.println("Wi-Fi credentials saved:");
      Serial.println("SSID: " + ssid);
      Serial.println("Password: " + password);

      // Connect to Wi-Fi
      connectToWiFi(ssid, password);

      // Register the device with the backend
      registerDeviceWithBackend(jwtToken);

      // Respond to the client
      server.send(200, "application/json", "{\"status\":\"success\",\"message\":\"Wi-Fi details saved and registration initiated.\"}");
    } else {
      server.send(400, "application/json", "{\"status\":\"error\",\"message\":\"Invalid SSID, password, or token.\"}");
    }
  } else {
    server.send(400, "application/json", "{\"status\":\"error\",\"message\":\"Invalid request.\"}");
  }
}

// Connect to Wi-Fi
void connectToWiFi(String ssid, String password) {
  Serial.println("Connecting to Wi-Fi...");
  WiFi.begin(ssid.c_str(), password.c_str());

  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) { // Retry 20 times
    delay(500);
    Serial.print(".");
    attempts++;
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nConnected to Wi-Fi!");
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());

    // Turn off the Access Point
    turnOffAP();
  } else {
    Serial.println("\nFailed to connect to Wi-Fi. Retrying...");
    handleWiFiRetry();
  }
}

// Turn off the Access Point
void turnOffAP() {
  if (WiFi.getMode() == WIFI_AP) {
    WiFi.softAPdisconnect(true);
    Serial.println("Access Point disabled.");
  }
}

// Handle Wi-Fi retry logic
void handleWiFiRetry() {
  delay(5000); // Wait before retrying
  ESP.restart(); // Restart the ESP32 to retry connecting
}

// Register the device with the backend
void registerDeviceWithBackend(String jwtToken) {
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("Registering device with backend...");
    WiFiClientSecure client;
    client.setInsecure(); // For development only

    HTTPClient http;

    String serverUrl = "https://5fjm2w12-5000.asse.devtunnels.ms/api/device/register";

    Serial.print("Connecting to server: ");
    Serial.println(serverUrl);

    // Prepare JSON payload
    String payload = "{";
    payload += "\"macAddress\":\"" + WiFi.macAddress() + "\","; 
    payload += "\"deviceName\":\"AquaFlow Tank Controller\","; 
    payload += "\"valveState\":false,"; 
    payload += "\"waterLevel\":0,";  // Send waterLevel to the server
    payload += "\"lowThreshold\":20,"; 
    payload += "\"highThreshold\":90"; 
    payload += "}";

    Serial.println("Payload: " + payload);

    http.begin(client, serverUrl); // Secure connection
    http.addHeader("Content-Type", "application/json");
    http.addHeader("Authorization", "Bearer " + jwtToken);

    int httpResponseCode = http.POST(payload);

    if (httpResponseCode > 0) {
      Serial.print("Response code: ");
      Serial.println(httpResponseCode);
      String response = http.getString();
      Serial.println("Response: " + response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(http.errorToString(httpResponseCode).c_str());
    }

    http.end();
  } else {
    Serial.println("Wi-Fi is not connected. Cannot register device.");
  }
}

// Send heartbeat to backend
void sendHeartbeat() {
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("Sending heartbeat...");

    WiFiClientSecure client;
    client.setInsecure(); // For development only

    HTTPClient http;
    String serverUrl = "https://5fjm2w12-5000.asse.devtunnels.ms/api/device/heartbeat";

    Serial.print("Connecting to server: ");
    Serial.println(serverUrl);

    // Prepare JSON payload
    String payload = "{";
    payload += "\"macAddress\":\"" + WiFi.macAddress() + "\"";
    payload += "}";

    http.begin(client, serverUrl); // Secure connection
    http.addHeader("Content-Type", "application/json");

    int httpResponseCode = http.POST(payload);

    if (httpResponseCode > 0) {
      Serial.print("Response code: ");
      Serial.println(httpResponseCode);
      String response = http.getString();
      Serial.println("Response: " + response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(http.errorToString(httpResponseCode).c_str());
    }

    http.end();
  } else {
    Serial.println("Wi-Fi is not connected. Cannot send heartbeat.");
  }
}

void readWaterLevel() {
  // Measure potentiometer value
  int potValue = analogRead(potPin); // Read potentiometer value (0 to 4095)
  waterLevel = map(potValue, 0, 4095, 0, 100); // Map the value to a percentage (0% to 100%)

  // Display the potentiometer reading and calculated water level percentage
  Serial.print("Potentiometer value: ");
  Serial.println(potValue);

  Serial.print("Water Level: ");
  Serial.print(waterLevel);
  Serial.println("%");

  if(oldWaterLevel != waterLevel) {
    updateWaterLevel();
  }

  if(waterLevel >= maxThreshold || waterLevel <= minThreshold) {
    autoControlValve();
  }

  oldWaterLevel = waterLevel;

  delay(1000); // Wait 1 second before the next measurement
}

void updateWaterLevel() {
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("Updating water level in the database...");

    WiFiClientSecure client;
    client.setInsecure(); // For development only

    HTTPClient http;
    String serverUrl = "https://5fjm2w12-5000.asse.devtunnels.ms/api/device/update-water-level";

    Serial.print("Connecting to server: ");
    Serial.println(serverUrl);

    // Prepare JSON payload
    String payload = "{";
    payload += "\"macAddress\":\"" + WiFi.macAddress() + "\",";
    payload += "\"waterLevel\":" + String((int)waterLevel) + "";
    payload += "}";

    Serial.println("Payload: " + payload); // Debugging

    http.begin(client, serverUrl); // Secure connection
    http.addHeader("Content-Type", "application/json");

    int httpResponseCode = http.PATCH(payload);

    if (httpResponseCode > 0) {
      Serial.print("Response code: ");
      Serial.println(httpResponseCode);
      String response = http.getString();
      Serial.println("Response: " + response);
    } else {
      Serial.print("Error on sending PATCH: ");
      Serial.println(http.errorToString(httpResponseCode).c_str());
    }

    http.end();
  } else {
      Serial.println("Wi-Fi is not connected. Cannot update valve state.");
  }
}

void autoControlValve() {
  if(waterLevel <= minThreshold) {
    digitalWrite(valvePin, HIGH);
    valveState = true;
    Serial.print("Valve Opened!");
  } else if(waterLevel >= maxThreshold) {
    digitalWrite(valvePin, LOW);
    valveState = false;
    Serial.print("Valve Closed!");
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("Updating valve state in the database...");

    WiFiClientSecure client;
    client.setInsecure(); // For development only

    HTTPClient http;
    String serverUrl = "https://5fjm2w12-5000.asse.devtunnels.ms/api/device/control-valve";

    Serial.print("Connecting to server: ");
    Serial.println(serverUrl);

    // Prepare JSON payload
    String payload = "{";
    payload += "\"macAddress\":\"" + WiFi.macAddress() + "\",";
    payload += "\"valveState\":" + String(valveState) + ","; // Boolean without quotes
    payload += "\"source\":\"device\"";
    payload += "}";

    Serial.println("Payload: " + payload); // Debugging

    http.begin(client, serverUrl); // Secure connection
    http.addHeader("Content-Type", "application/json");

    int httpResponseCode = http.POST(payload);

    if (httpResponseCode > 0) {
      Serial.print("Response code: ");
      Serial.println(httpResponseCode);
      String response = http.getString();
      Serial.println("Response: " + response);
    } else {
      Serial.print("Error on sending PATCH: ");
      Serial.println(http.errorToString(httpResponseCode).c_str());
    }

    http.end();
  } else {
    Serial.println("Wi-Fi is not connected. Cannot update valve state.");
  }
}


void manualValveControl() {
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("Get valve state in the database...");

    WiFiClientSecure client;
    client.setInsecure(); // For development only

    HTTPClient http;
    String serverUrl = "https://5fjm2w12-5000.asse.devtunnels.ms/api/device/get-valve-state";

    Serial.print("Connecting to server: ");
    Serial.println(serverUrl);

    // Prepare JSON payload
    String payload = "{";
    payload += "\"macAddress\":\"" + WiFi.macAddress() + "\"";
    payload += "}";

    Serial.println("Payload: " + payload); // Debugging

    http.begin(client, serverUrl); // Secure connection
    http.addHeader("Content-Type", "application/json");

    int httpResponseCode = http.POST(payload);

    if (httpResponseCode > 0) {
      Serial.print("Response code: ");
      Serial.println(httpResponseCode);

      // Read and parse the response
      String response = http.getString();
      Serial.println("Response: " + response);

      // Parse the JSON response
      StaticJsonDocument<200> doc;
      DeserializationError error = deserializeJson(doc, response);

      if (error) {
        Serial.print("JSON deserialization failed: ");
        Serial.println(error.c_str());
      } else {
        // Extract the status value
        bool status = doc["status"];
        if (status && valveState != true) {
          digitalWrite(valvePin, HIGH);
          valveState = true;
          Serial.print("Valve Opened!");
        } else if (status == false && valveState != false) {
          digitalWrite(valvePin, LOW);
          valveState = false;
          Serial.print("Valve Closed!");
        }
      }

      // Handle true/false response
      // if (response == "true" && valveState != true) {
      //   digitalWrite(valvePin, HIGH);
      //   valveState = true;
      //   Serial.print("Valve Opened!");
      // } else if (response == "false" && valveState != false) {
      //   digitalWrite(valvePin, LOW);
      //   valveState = false;
      //   Serial.print("Valve Closed!");
      // } else {
      //   Serial.println("Unexpected response: " + response);
      // }
    } else {
      Serial.print("Error on sending PATCH: ");
      Serial.println(http.errorToString(httpResponseCode).c_str());
    }

    http.end();
  } else {
    Serial.println("Wi-Fi is not connected. Cannot get valve state.");
  }
  delay(1000);
}

// Extract values from a JSON string
String extractValue(String json, String key) {
  int start = json.indexOf(key) + key.length() + 3;
  int end = json.indexOf("\"", start);
  return json.substring(start, end);
}
