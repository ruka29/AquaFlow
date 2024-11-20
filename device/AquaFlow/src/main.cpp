#include <WiFi.h>
#include <WebServer.h>
#include <Preferences.h>
#include <ArduinoJson.h>

// Device Variables
String deviceName = "AquaFlow_Device_001";
String deviceID; // Device MAC address (unique ID)
bool valveState = false; // false = closed, true = open
float waterLevel = 0.0;
float lowThreshold = 20.0;  // Default low threshold
float highThreshold = 80.0; // Default high threshold

// WiFi and Server Variables
const char *apSSID = "AquaFlow_Setup";
const char *apPassword = "12345678";
char ssid[32];
char password[32];
WebServer server(80);
Preferences preferences;

bool isConfigured = false;

// JSON Buffer
StaticJsonDocument<512> jsonBuffer;

// Function to open/close the valve
void controlValve(bool state) {
  valveState = state;
  digitalWrite(2, state ? HIGH : LOW); // Assuming valve control is on pin 2
}

// Function to update water level (replace with actual sensor reading)
void updateWaterLevel() {
  // Example: Simulate water level with a random number (replace with actual sensor code)
  waterLevel = random(0, 101);
}

// Function to save Wi-Fi credentials to flash memory
void saveWiFiCredentials(const char *wifiSSID, const char *wifiPassword) {
  preferences.begin("WiFiCreds", false); // Namespace: "WiFiCreds"
  preferences.putString("ssid", wifiSSID);
  preferences.putString("password", wifiPassword);
  preferences.end();
  Serial.println("WiFi credentials saved to flash memory.");
}

// Function to load Wi-Fi credentials from flash memory
bool loadWiFiCredentials() {
  preferences.begin("WiFiCreds", true); // Open in read-only mode
  String storedSSID = preferences.getString("ssid", "");
  String storedPassword = preferences.getString("password", "");
  preferences.end();

  if (storedSSID != "" && storedPassword != "") {
    storedSSID.toCharArray(ssid, 32);
    storedPassword.toCharArray(password, 32);
    Serial.println("WiFi credentials loaded from flash memory.");
    return true;
  } else {
    Serial.println("No WiFi credentials found in flash memory.");
    return false;
  }
}

// Function to clear Wi-Fi credentials (optional, for factory reset)
void clearWiFiCredentials() {
  preferences.begin("WiFiCreds", false);
  preferences.clear();
  preferences.end();
  Serial.println("WiFi credentials cleared from flash memory.");
}

// Handle WiFi credentials submission
void handleWiFiConfig() {
  if (server.hasArg("ssid") && server.hasArg("password")) {
    String inputSSID = server.arg("ssid");
    String inputPassword = server.arg("password");
    inputSSID.toCharArray(ssid, 32);
    inputPassword.toCharArray(password, 32);

    saveWiFiCredentials(ssid, password); // Save to flash memory

    server.send(200, "text/plain", "WiFi credentials received. Rebooting to connect to home WiFi...");
    delay(1000);
    isConfigured = true;
    WiFi.softAPdisconnect(true);
    ESP.restart();
  } else {
    server.send(400, "text/plain", "Invalid credentials");
  }
}

// Handle device status
void handleStatus() {
  updateWaterLevel();

  jsonBuffer.clear();
  jsonBuffer["deviceID"] = deviceID;
  jsonBuffer["deviceName"] = deviceName;
  jsonBuffer["valveState"] = valveState;
  jsonBuffer["waterLevel"] = waterLevel;
  jsonBuffer["lowThreshold"] = lowThreshold;
  jsonBuffer["highThreshold"] = highThreshold;

  String response;
  serializeJson(jsonBuffer, response);
  server.send(200, "application/json", response);
}

// Handle manual valve control
void handleValveControl() {
  if (server.hasArg("state")) {
    String state = server.arg("state");
    if (state == "open") {
      controlValve(true);
      server.send(200, "text/plain", "Valve opened");
    } else if (state == "close") {
      controlValve(false);
      server.send(200, "text/plain", "Valve closed");
    } else {
      server.send(400, "text/plain", "Invalid state");
    }
  } else {
    server.send(400, "text/plain", "Missing state parameter");
  }
}

// Handle threshold update
void handleUpdateThreshold() {
  if (server.hasArg("low") && server.hasArg("high")) {
    lowThreshold = server.arg("low").toFloat();
    highThreshold = server.arg("high").toFloat();
    server.send(200, "text/plain", "Thresholds updated");
  } else {
    server.send(400, "text/plain", "Missing threshold parameters");
  }
}

// Setup Access Point
void setupAP() {
  WiFi.softAP(apSSID, apPassword);
  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP Address: ");
  Serial.println(IP);

  server.on("/wifi-config", HTTP_POST, handleWiFiConfig);
  server.begin();
  Serial.println("Web server started for WiFi configuration");
}

// Connect to Home WiFi
void connectToWiFi() {
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nConnected to WiFi");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
}

// Setup Web Server for Home WiFi Mode
void setupHomeServer() {
  server.on("/status", HTTP_GET, handleStatus);
  server.on("/valve-control", HTTP_POST, handleValveControl);
  server.on("/update-threshold", HTTP_POST, handleUpdateThreshold);
  server.begin();
  Serial.println("Web server started for device control");
}

void setup() {
  Serial.begin(115200);
  pinMode(2, OUTPUT); // Valve control pin

  // Get MAC address as unique ID
  deviceID = WiFi.macAddress();
  Serial.print("Device ID (MAC Address): ");
  Serial.println(deviceID);

  // Load Wi-Fi credentials or start in AP mode
  if (loadWiFiCredentials()) {
    connectToWiFi();
    setupHomeServer();
  } else {
    setupAP();
  }
}

void loop() {
  server.handleClient();

  // Automatic valve control based on thresholds
  updateWaterLevel();
  if (waterLevel < lowThreshold && !valveState) {
    controlValve(true);
  } else if (waterLevel > highThreshold && valveState) {
    controlValve(false);
  }
}
