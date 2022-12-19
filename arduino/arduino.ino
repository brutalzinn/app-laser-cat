/***
  Exemplo de https://josecintra.com/blog/comunicacao-websockets-nodemcu-esp8266/
***/

#include <ESP8266WiFi.h>
#include <WebSocketsServer.h>
#include "config.h"
#include <Servo.h>

//Correção nivel lógico invertido
#define ON LOW
#define OFF HIGH

Servo BASE_SERVO;
Servo VERTICAL_SERVO;

int BASE_SERVO_PIN = 5;
int VERTICAL_SERVO_PIN = 4;
int LASER_PIN = 16;

WebSocketsServer webSocket = WebSocketsServer(SOCK_PORT); // Recebe dados do cliente

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t lenght) {

  switch (type) {
    case WStype_DISCONNECTED:
      break;

    case WStype_CONNECTED:
      { IPAddress ip = webSocket.remoteIP(num);
        Serial.println(ip);
      }
      break;

    case WStype_TEXT:
      { String text = String((char *) &payload[0]);
        Serial.print(text);
        Serial.print(num);
        Serial.println(type);

        if (text == "LASER_ON") {
          digitalWrite(LASER_PIN, ON);
          webSocket.sendTXT(0, "LASER_ON");
        }
        else if (text == "LASER_OFF")  {
          digitalWrite(LASER_PIN, OFF);
          webSocket.sendTXT(0, "LASER_OFF");
        }
        else if (text == "HAND") {
          Serial.println("SENDING SHAKE TO DEVICE");
          webSocket.sendTXT(0, "shake");
          return;
        }
        else {
          int index = text.indexOf(',');
          String val_x = text.substring(0, index);
          String val_y = text.substring(text.lastIndexOf(','),text.length());

          Serial.print("RECEBIDO:");
          Serial.print(val_x);
          Serial.print(val_y);

       
          BASE_SERVO.write(val_x.toInt());
          delay(15);
          VERTICAL_SERVO.write(val_y.toInt());   
          delay(15);

          webSocket.sendTXT(0, "MOVING_SERVO");

        }

      }
      break;

  }

}

void setup() {

  // Inicialização do LED
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
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

  for(int i= 0;i < 180; i++){

     BASE_SERVO.write(i);
     delay(15);
     VERTICAL_SERVO.write(i);   
  }


  webSocket.begin();
  webSocket.onEvent(webSocketEvent);

}

void loop() {
  webSocket.loop();
}
