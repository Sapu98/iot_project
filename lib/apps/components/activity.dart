
import 'package:latlong/latlong.dart';

class Activity{
  String name;
  DateTime dateTime;
  LatLng start;
  LatLng end;
  List<LatLng> points;

  Activity(String name, DateTime dateTime, List<LatLng> points){
    this.name = name;
    this.dateTime = dateTime;
    this.start = points[0];
    this.end = points[points.length-1];
    this.points = points;
  }

  String getName(){
    return this.name;
  }

  DateTime getDateTime(){
    return this.dateTime;
  }

  LatLng getStart(){
    return this.start;
  }

  LatLng getEnd(){
    return this.end;
  }

  List<LatLng> getPoints(){
    return this.points;
  }

  getMiddlePoint(){
    return this.points[points.length~/2];
  }

  void setName(String name){
    this.name = name;
  }

  void setDateTime(DateTime dateTime){
    this.dateTime = dateTime;
  }

  void addPoint(LatLng point){
    this.points.add(point);
  }


}