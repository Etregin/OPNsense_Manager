import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:opnsense_manager/models/thermal_sensor.dart';

void main() {
  group('ThermalSensor', () {
    test('parses actual API response correctly', () {
      // Actual API response from user
      const jsonString = '''
      [
        {
          "device": "dev.cpu.0.temperature",
          "device_seq": 0,
          "temperature": "48.0",
          "type_translated": "CPU",
          "type": "cpu"
        },
        {
          "device": "hw.acpi.thermal.tz0.temperature",
          "device_seq": 0,
          "temperature": "26.9",
          "type_translated": "Zone",
          "type": "zone"
        }
      ]
      ''';

      final List<dynamic> jsonList = json.decode(jsonString);
      final sensors = jsonList
          .map((json) => ThermalSensor.fromJson(json as Map<String, dynamic>))
          .toList();

      // Verify we got 2 sensors
      expect(sensors.length, 2);

      // Verify first sensor (CPU)
      final cpuSensor = sensors[0];
      expect(cpuSensor.device, 'dev.cpu.0.temperature');
      expect(cpuSensor.deviceSeq, 0);
      expect(cpuSensor.temperature, '48.0');
      expect(cpuSensor.typeTranslated, 'CPU');
      expect(cpuSensor.type, 'cpu');
      expect(cpuSensor.temperatureValue, 48.0);

      // Verify second sensor (Zone)
      final zoneSensor = sensors[1];
      expect(zoneSensor.device, 'hw.acpi.thermal.tz0.temperature');
      expect(zoneSensor.deviceSeq, 0);
      expect(zoneSensor.temperature, '26.9');
      expect(zoneSensor.typeTranslated, 'Zone');
      expect(zoneSensor.type, 'zone');
      expect(zoneSensor.temperatureValue, 26.9);
    });

    test('temperatureValue getter handles plain numbers without °C suffix', () {
      final sensor = ThermalSensor(
        device: 'test.device',
        deviceSeq: 0,
        temperature: '48.0',
        typeTranslated: 'Test',
        type: 'test',
      );

      expect(sensor.temperatureValue, 48.0);
    });

    test('temperatureValue getter handles decimal values', () {
      final sensor = ThermalSensor(
        device: 'test.device',
        deviceSeq: 0,
        temperature: '26.9',
        typeTranslated: 'Test',
        type: 'test',
      );

      expect(sensor.temperatureValue, 26.9);
    });

    test('temperatureValue getter handles values with C suffix (legacy)', () {
      final sensor = ThermalSensor(
        device: 'test.device',
        deviceSeq: 0,
        temperature: '45.0C',
        typeTranslated: 'Test',
        type: 'test',
      );

      expect(sensor.temperatureValue, 45.0);
    });

    test('temperatureValue getter handles values with °C suffix (legacy)', () {
      final sensor = ThermalSensor(
        device: 'test.device',
        deviceSeq: 0,
        temperature: '45.0°C',
        typeTranslated: 'Test',
        type: 'test',
      );

      expect(sensor.temperatureValue, 45.0);
    });

    test('temperatureValue getter handles empty string', () {
      final sensor = ThermalSensor(
        device: 'test.device',
        deviceSeq: 0,
        temperature: '',
        typeTranslated: 'Test',
        type: 'test',
      );

      expect(sensor.temperatureValue, 0.0);
    });

    test('temperatureValue getter handles invalid format', () {
      final sensor = ThermalSensor(
        device: 'test.device',
        deviceSeq: 0,
        temperature: 'invalid',
        typeTranslated: 'Test',
        type: 'test',
      );

      expect(sensor.temperatureValue, 0.0);
    });

    test('toJson produces correct format', () {
      final sensor = ThermalSensor(
        device: 'dev.cpu.0.temperature',
        deviceSeq: 0,
        temperature: '48.0',
        typeTranslated: 'CPU',
        type: 'cpu',
      );

      final json = sensor.toJson();

      expect(json['device'], 'dev.cpu.0.temperature');
      expect(json['device_seq'], 0);
      expect(json['temperature'], '48.0');
      expect(json['type_translated'], 'CPU');
      expect(json['type'], 'cpu');
    });

    test('equality works correctly', () {
      final sensor1 = ThermalSensor(
        device: 'dev.cpu.0.temperature',
        deviceSeq: 0,
        temperature: '48.0',
        typeTranslated: 'CPU',
        type: 'cpu',
      );

      final sensor2 = ThermalSensor(
        device: 'dev.cpu.0.temperature',
        deviceSeq: 0,
        temperature: '50.0', // Different temperature
        typeTranslated: 'CPU',
        type: 'cpu',
      );

      final sensor3 = ThermalSensor(
        device: 'dev.cpu.1.temperature', // Different device
        deviceSeq: 1,
        temperature: '48.0',
        typeTranslated: 'CPU',
        type: 'cpu',
      );

      expect(sensor1, sensor2); // Same device and deviceSeq
      expect(sensor1, isNot(sensor3)); // Different device
    });
  });
}
