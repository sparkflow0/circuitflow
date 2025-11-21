insert into public.components (name, type, slug, category, image_url, width, height, pins, animations, metadata) values
('Arduino Uno R3', 'ARDUINO', 'arduino-uno-r3', 'microcontroller', null, 320, 210, '[
  {"id":"0","label":"0 / RX","x":22,"y":12,"voltage":"5V"},
  {"id":"1","label":"1 / TX","x":38,"y":12,"voltage":"5V"},
  {"id":"2","label":"2","x":54,"y":12,"voltage":"5V"},
  {"id":"3","label":"3 ~","x":70,"y":12,"voltage":"5V"},
  {"id":"4","label":"4","x":86,"y":12,"voltage":"5V"},
  {"id":"5","label":"5 ~","x":102,"y":12,"voltage":"5V"},
  {"id":"6","label":"6 ~","x":118,"y":12,"voltage":"5V"},
  {"id":"7","label":"7","x":134,"y":12,"voltage":"5V"},
  {"id":"8","label":"8","x":150,"y":12,"voltage":"5V"},
  {"id":"9","label":"9 ~","x":166,"y":12,"voltage":"5V"},
  {"id":"10","label":"10 ~","x":182,"y":12,"voltage":"5V"},
  {"id":"11","label":"11 ~","x":198,"y":12,"voltage":"5V"},
  {"id":"12","label":"12","x":214,"y":12,"voltage":"5V"},
  {"id":"13","label":"13","x":230,"y":12,"voltage":"5V"},
  {"id":"GND1","label":"GND","x":246,"y":12,"voltage":"GND"},
  {"id":"AREF","label":"AREF","x":262,"y":12,"voltage":"REF"},
  {"id":"SDA","label":"SDA","x":278,"y":12,"voltage":"5V"},
  {"id":"SCL","label":"SCL","x":294,"y":12,"voltage":"5V"},
  {"id":"IOREF","label":"IOREF","x":30,"y":194,"voltage":"5V"},
  {"id":"RESET","label":"RESET","x":46,"y":194,"voltage":"5V"},
  {"id":"3.3V","label":"3.3V","x":62,"y":194,"voltage":"3V3"},
  {"id":"5V","label":"5V","x":78,"y":194,"voltage":"5V"},
  {"id":"GND2","label":"GND","x":94,"y":194,"voltage":"GND"},
  {"id":"GND3","label":"GND","x":110,"y":194,"voltage":"GND"},
  {"id":"VIN","label":"VIN","x":126,"y":194,"voltage":"VIN"},
  {"id":"A0","label":"A0","x":160,"y":194,"voltage":"ANALOG"},
  {"id":"A1","label":"A1","x":176,"y":194,"voltage":"ANALOG"},
  {"id":"A2","label":"A2","x":192,"y":194,"voltage":"ANALOG"},
  {"id":"A3","label":"A3","x":208,"y":194,"voltage":"ANALOG"},
  {"id":"A4","label":"A4","x":224,"y":194,"voltage":"ANALOG"},
  {"id":"A5","label":"A5","x":240,"y":194,"voltage":"ANALOG"}
]'::jsonb, '[]'::jsonb, '{"default_voltage":"5V","platform":"avr"}'::jsonb),
('ESP32 DevKit', 'ESP32', 'esp32-devkit', 'microcontroller', null, 180, 260, '[
  {"id":"EN","label":"EN","x":12,"y":28,"voltage":"3V3"},
  {"id":"VP","label":"VP","x":12,"y":44,"voltage":"3V3"},
  {"id":"VN","label":"VN","x":12,"y":60,"voltage":"3V3"},
  {"id":"34","label":"34","x":12,"y":76,"voltage":"3V3"},
  {"id":"35","label":"35","x":12,"y":92,"voltage":"3V3"},
  {"id":"32","label":"32","x":12,"y":108,"voltage":"3V3"},
  {"id":"33","label":"33","x":12,"y":124,"voltage":"3V3"},
  {"id":"25","label":"25","x":12,"y":140,"voltage":"3V3"},
  {"id":"26","label":"26","x":12,"y":156,"voltage":"3V3"},
  {"id":"27","label":"27","x":12,"y":172,"voltage":"3V3"},
  {"id":"14","label":"14","x":12,"y":188,"voltage":"3V3"},
  {"id":"12","label":"12","x":12,"y":204,"voltage":"3V3"},
  {"id":"GND","label":"GND","x":12,"y":220,"voltage":"GND"},
  {"id":"VIN","label":"VIN","x":12,"y":236,"voltage":"VIN"},
  {"id":"23","label":"23","x":168,"y":28,"voltage":"3V3"},
  {"id":"22","label":"22","x":168,"y":44,"voltage":"3V3"},
  {"id":"1","label":"TX0","x":168,"y":60,"voltage":"3V3"},
  {"id":"3","label":"RX0","x":168,"y":76,"voltage":"3V3"},
  {"id":"21","label":"21","x":168,"y":92,"voltage":"3V3"},
  {"id":"GND2","label":"GND","x":168,"y":108,"voltage":"GND"},
  {"id":"19","label":"19","x":168,"y":124,"voltage":"3V3"},
  {"id":"18","label":"18","x":168,"y":140,"voltage":"3V3"},
  {"id":"5","label":"5","x":168,"y":156,"voltage":"3V3"},
  {"id":"17","label":"17","x":168,"y":172,"voltage":"3V3"},
  {"id":"16","label":"16","x":168,"y":188,"voltage":"3V3"},
  {"id":"4","label":"4","x":168,"y":204,"voltage":"3V3"},
  {"id":"2","label":"2","x":168,"y":220,"voltage":"3V3"},
  {"id":"15","label":"15","x":168,"y":236,"voltage":"3V3"},
  {"id":"13","label":"13","x":168,"y":252,"voltage":"3V3"}
]'::jsonb, '[]'::jsonb, '{"default_voltage":"3V3","platform":"esp32"}'::jsonb),
('LED 5mm', 'LED', 'led-5mm', 'passive', null, 36, 80, '[
  {"id":"anode","label":"Anode","x":26,"y":72,"voltage":"VCC"},
  {"id":"cathode","label":"Cathode","x":10,"y":72,"voltage":"GND"}
]'::jsonb, '[]'::jsonb, '{"default_voltage":"forward"}'::jsonb),
('RGB LED', 'RGB_LED', 'rgb-led', 'passive', null, 44, 86, '[
  {"id":"R","label":"Red","x":8,"y":78,"voltage":"VCC"},
  {"id":"cathode","label":"Common","x":18,"y":78,"voltage":"GND"},
  {"id":"G","label":"Green","x":28,"y":78,"voltage":"VCC"},
  {"id":"B","label":"Blue","x":38,"y":78,"voltage":"VCC"}
]'::jsonb, '[]'::jsonb, '{"default_voltage":"forward"}'::jsonb),
('Resistor', 'RESISTOR', 'resistor', 'passive', null, 90, 24, '[
  {"id":"t1","label":"Terminal 1","x":6,"y":12,"voltage":"passive"},
  {"id":"t2","label":"Terminal 2","x":84,"y":12,"voltage":"passive"}
]'::jsonb, '[]'::jsonb, '{}'),
('Push Button', 'BUTTON', 'push-button', 'input', null, 60, 60, '[
  {"id":"1a","x":6,"y":6,"voltage":"passive"},
  {"id":"1b","x":6,"y":54,"voltage":"passive"},
  {"id":"2a","x":54,"y":6,"voltage":"passive"},
  {"id":"2b","x":54,"y":54,"voltage":"passive"}
]'::jsonb, '[]'::jsonb, '{}'),
('Micro Servo', 'SERVO', 'micro-servo', 'actuator', null, 90, 110, '[
  {"id":"GND","x":22,"y":104,"voltage":"GND"},
  {"id":"VCC","x":45,"y":104,"voltage":"5V"},
  {"id":"SIG","x":68,"y":104,"voltage":"PWM"}
]'::jsonb, '[]'::jsonb, '{}'),
('DC Motor', 'MOTOR', 'dc-motor', 'actuator', null, 90, 90, '[
  {"id":"pos","x":14,"y":78,"voltage":"VCC"},
  {"id":"neg","x":76,"y":78,"voltage":"GND"}
]'::jsonb, '[]'::jsonb, '{}'),
('Buzzer', 'BUZZER', 'buzzer', 'actuator', null, 60, 60, '[
  {"id":"pos","x":12,"y":52,"voltage":"VCC"},
  {"id":"neg","x":48,"y":52,"voltage":"GND"}
]'::jsonb, '[]'::jsonb, '{}'),
('Potentiometer', 'POT', 'potentiometer', 'input', null, 70, 70, '[
  {"id":"GND","x":12,"y":64,"voltage":"GND"},
  {"id":"SIG","x":35,"y":64,"voltage":"ANALOG"},
  {"id":"VCC","x":58,"y":64,"voltage":"VCC"}
]'::jsonb, '[]'::jsonb, '{}'),
('Photoresistor', 'LDR', 'photoresistor', 'input', null, 60, 60, '[
  {"id":"t1","x":12,"y":54,"voltage":"passive"},
  {"id":"t2","x":48,"y":54,"voltage":"passive"}
]'::jsonb, '[]'::jsonb, '{}'),
('Ultrasonic HC-SR04', 'ULTRASONIC', 'ultrasonic-hcsr04', 'sensor', null, 120, 60, '[
  {"id":"VCC","x":20,"y":54,"voltage":"5V"},
  {"id":"TRIG","x":44,"y":54,"voltage":"5V"},
  {"id":"ECHO","x":68,"y":54,"voltage":"5V"},
  {"id":"GND","x":92,"y":54,"voltage":"GND"}
]'::jsonb, '[]'::jsonb, '{}'),
('7-Segment', 'SEVEN_SEG', 'seven-seg', 'display', null, 80, 100, '[
  {"id":"e","x":12,"y":94,"voltage":"5V"},
  {"id":"d","x":22,"y":94,"voltage":"5V"},
  {"id":"com","x":38,"y":94,"voltage":"5V"},
  {"id":"c","x":54,"y":94,"voltage":"5V"},
  {"id":"dp","x":68,"y":94,"voltage":"5V"},
  {"id":"b","x":68,"y":6,"voltage":"5V"},
  {"id":"a","x":54,"y":6,"voltage":"5V"},
  {"id":"com2","x":38,"y":6,"voltage":"5V"},
  {"id":"f","x":22,"y":6,"voltage":"5V"},
  {"id":"g","x":12,"y":6,"voltage":"5V"}
]'::jsonb, '[]'::jsonb, '{}');
