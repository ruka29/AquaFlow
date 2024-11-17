#include <Arduino.h>

#define WATER_SENSOR_PIN 34  // ADC pin for water level sensor
#define RELAY_PIN 23         // GPIO pin for relay control

int waterLevel = 0;          // Variable to store water level reading
int lowThreshold = 20;       // Open the valve when water level is 20% or below
int highThreshold = 95;      // Close the valve when water level is 95% or above

void setup() {
  Serial.begin(115200);              // Initialize serial monitor
  pinMode(WATER_SENSOR_PIN, INPUT);  // Set water sensor pin as input
  pinMode(RELAY_PIN, OUTPUT);        // Set relay pin as output
  digitalWrite(RELAY_PIN, HIGH);     // Initialize relay off (active low)
  Serial.println("Water Tank Automation Simulation Started!");
}

void loop() {
  // Read water level from potentiometer (simulate water sensor)
  waterLevel = analogRead(WATER_SENSOR_PIN);

  // Map ADC reading (0–4095) to percentage (0–100%)
  int waterPercentage = map(waterLevel, 0, 4095, 0, 100);

  // Print water level percentage to Serial Monitor
  Serial.print("Water Level: ");
  Serial.print(waterPercentage);
  Serial.println("%");

  // Control the relay (and valve) based on water level
  if (waterPercentage <= lowThreshold) {
    // Open the valve (relay ON)
    digitalWrite(RELAY_PIN, LOW);  // Active low
    Serial.println("Valve Open (Filling Tank)");
  } else if (waterPercentage >= highThreshold) {
    // Close the valve (relay OFF)
    digitalWrite(RELAY_PIN, HIGH);  // Inactive
    Serial.println("Valve Closed (Tank Full)");
  }

  delay(1000); // Wait for 1 second before the next reading
}