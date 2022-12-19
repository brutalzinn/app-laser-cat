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


 Servo baseServo;
 Servo verticalServo;  

int baseServo_PIN = 3; //Pino ligado ao X do joystick
int verticalServo_PIN = 4; //Pino ligado ao Y do joystick

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
        Serial.println(text);
        Serial.println(num);
        Serial.println(type);

        if (text == "LASER_ON") {
          digitalWrite(LED_BUILTIN, ON);
          webSocket.sendTXT(0, "LASER_ON");
        }
        if (text == "LASER_OFF")  {
          digitalWrite(LED_BUILTIN, OFF);
          webSocket.sendTXT(0, "LASER_OFF");
        }

        if(text == "HAND"){
          Serial.println("SENDING SHAKE TO DEVICE");
          webSocket.sendTXT(0, "shake");
        }
          int index = text.indexOf(',');
          String val_x = text.substring(0,index);
          String val_y = text.substring(1,index);

           
            Serial.println("Pos");
            Serial.println(val_x);
                    Serial.println(val_y);

      }
        
      }
      break;

  }

}

void setup() {
  
  // Inicialização do LED
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  baseServo.attach(baseServo_PIN);
  verticalServo.attach(verticalServo_PIN);
  
  digitalWrite(LED_BUILTIN, OFF);
  // Conexões wi-fi e websocket
  WiFi.begin(SSID, PASSWD);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(". ");
    delay(100);
  }
  Serial.println(WiFi.localIP());
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);

}

void loop() {
  webSocket.loop();
}
