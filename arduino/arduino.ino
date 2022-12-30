#include <ESP8266WiFi.h>
#include <WebSocketsServer.h>
#include "config.h"
#include <Servo.h>

#define ON LOW
#define OFF HIGH

Servo BASE_SERVO;
Servo VERTICAL_SERVO;

int BASE_SERVO_PIN = 5;
int VERTICAL_SERVO_PIN = 4;
int LASER_PIN = 0;

WebSocketsServer webSocket = WebSocketsServer(SOCK_PORT); // Recebe dados do cliente

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t lenght) {

  switch (type) {
    case WStype_DISCONNECTED:
      break;

    case WStype_CONNECTED:
      { IPAddress ip = webSocket.remoteIP(num);
      Serial.print("Connected:");
      Serial.println(ip);
      digitalWrite(LASER_PIN, LOW);
      webSocket.sendTXT(0, "LASER_OFF");
      }
      break;

    case WStype_TEXT:
      { 
        String text = String((char *) &payload[0]);
        messangeHandler(text);
        webSocket.sendTXT(0, "OK");
      }
      break;
  }
}

void messangeHandler(String text){
   laserHandle(text);
   handShakeHandle(text);
   servoHandle(text);
}

void laserHandle(String text){
  int index = text.lastIndexOf("LASER_");
  Serial.println("OK");
  Serial.println("TEXT:" + text);
  Serial.println("LENGHT:" + text.length());
  if(index == -1){
    return;
  }
 
  String val = text.substring(5, text.length());
  Serial.print("VAL" + val);
  int power = val.toInt();     

  Serial.println("--START POWER--");
  Serial.println(power);
  Serial.println("--END POWER--");
  analogWrite(LASER_PIN, power);
  webSocket.sendTXT(0, "LASER_POWER" + power);
}

void handShakeHandle(String text){
    if (text != "HAND") {
       return;
    }
    Serial.println("SENDING SHAKE TO DEVICE");
    webSocket.sendTXT(0, "shake");
}

void servoHandle(String text){
  int index = text.indexOf(',');
   if(index == -1){
    return;
  }
  String val_x = text.substring(0, index);
  String val_y = text.substring(index + 1,text.length());
  
  Serial.print("MOVING_SERVO:");
  Serial.println(val_x);
  Serial.println(val_y);
  
  int pos1 = val_x.toInt();     
  int pos2 = val_y.toInt();
 
  BASE_SERVO.write(pos1);
  VERTICAL_SERVO.write(pos2); 
  
  webSocket.sendTXT(0, "MOVING_SERVO");
}

void setup() {

  // Inicialização do LED
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(LASER_PIN, OUTPUT);

  BASE_SERVO.attach(BASE_SERVO_PIN);
  VERTICAL_SERVO.attach(VERTICAL_SERVO_PIN);
  digitalWrite(LED_BUILTIN, OFF);
  WiFi.begin(SSID, PASSWD);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(". ");
    delay(100);
  }
  Serial.println(WiFi.localIP());
  digitalWrite(LED_BUILTIN, ON);
 
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
  

}

void loop() {
  webSocket.loop();
}
