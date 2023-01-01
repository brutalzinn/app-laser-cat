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

void webSocketEvent(uint8_t num, WStype_t type, uint8_t *payload, size_t lenght)
{

  switch (type)
  {
  case WStype_DISCONNECTED:
    analogWrite(LASER_PIN, 0);
    digitalWrite(LED_BUILTIN, OFF);
    BASE_SERVO.write(90);
    VERTICAL_SERVO.write(90);
    break;

  case WStype_CONNECTED:
  {
    IPAddress ip = webSocket.remoteIP(num);
    Serial.print("Connected:");
    Serial.println(ip);
    BASE_SERVO.write(90);
    VERTICAL_SERVO.write(90);
    analogWrite(LASER_PIN, 0);
    digitalWrite(LED_BUILTIN, ON);
    webSocket.sendTXT(0, "LASER_0");
  }
  break;

  case WStype_TEXT:
  {
    String text = String((char *)payload);
    messangeHandler(text);
  }
  break;
  }
}

void messangeHandler(String text)
{
  laserHandle(text);
  handShakeHandle(text);
  servoHandle(text);
}

void laserHandle(String text)
{
  int index = text.indexOf("LASER_");
  if (index == -1)
  {
    return;
  }
  int val = text.substring(6, text.length()).toInt();
  analogWrite(LASER_PIN, val);
  webSocket.sendTXT(0, text);
}

void handShakeHandle(String text)
{
  if (text != "HAND")
  {
    return;
  }
  Serial.println("SENDING SHAKE TO DEVICE");
  webSocket.sendTXT(0, "SHAKE");
}

void servoHandle(String text)
{
  int index = text.indexOf(',');
  if (index == -1)
  {
    return;
  }
  String val_x = text.substring(0, index);
  String val_y = text.substring(index + 1, text.length());
  int pos1 = val_x.toInt();
  int pos2 = val_y.toInt();
  BASE_SERVO.write(pos1);
  VERTICAL_SERVO.write(pos2);
  webSocket.sendTXT(0, "MOVING_SERVO");
}

void setup()
{

  // Inicialização do LED
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(LASER_PIN, OUTPUT);
  digitalWrite(LED_BUILTIN, OFF);

  BASE_SERVO.attach(BASE_SERVO_PIN);
  VERTICAL_SERVO.attach(VERTICAL_SERVO_PIN);

  BASE_SERVO.write(90);
  VERTICAL_SERVO.write(90);

  WiFi.begin(SSID, PASSWD);
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(". ");
    delay(100);
  }
  Serial.println(WiFi.localIP());

  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
}

void loop()
{
  webSocket.loop();
}
