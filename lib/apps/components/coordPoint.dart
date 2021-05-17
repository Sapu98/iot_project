
import 'package:latlong/latlong.dart';

class CoordPoint{

  double _latitude;
  double _longitude;
  double _altitude;
  double _speed;
  String _dateTime;

  CoordPoint(double latitude, double longitude, double altitude, double speed, String dateTime){
    this._latitude = latitude;
    this._longitude = longitude;
    this._altitude = altitude;
    this._speed = speed;
    this._dateTime = dateTime;
  }

  double getLongitude(){
    return this._longitude;
  }
  double getLatitude(){
    return this._latitude;
  }

  double getAltitude(){
    return this._altitude;
  }

  double getSpeed(){
    return this._speed;
  }

  String getDateTime(){
    return _dateTime;
  }

  LatLng toLatLng(){
    return new LatLng(_latitude,_longitude);
  }

  String toString(){
    return "Latitude:" + _latitude.toString()
        + " Longitude:"+ _longitude.toString()
    + " Altitude:"+ _altitude.toString()
    + " Speed:"+_speed.toString()
    + " DateTime:"+ _dateTime;
  }
}