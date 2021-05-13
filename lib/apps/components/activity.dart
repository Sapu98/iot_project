
import 'package:latlong/latlong.dart';

import 'coordPoint.dart';

class Activity{
  String _name;
  List<CoordPoint> _points;

  Activity(String name, List<CoordPoint> points){
    this._name = name;
    this._points = points;
  }

  String getName(){
    return this._name;
  }

  DateTime getBeginTime(){
    return this._points[0].getDateTime();
  }

  DateTime getEndTime(){
    return this._points[_points.length-1].getDateTime();
  }

  CoordPoint getFirstPos(){
    return this._points[0];
  }

  CoordPoint getLastPos(){
    if(this._points.length == 0){
      return new CoordPoint(0, 0, 0, 0, null);
    }
    return this._points[_points.length-1];
  }

  List<CoordPoint> getCoordPoints(){
    return this._points;
  }

  List<LatLng> getPointsLatLng(){
    //modo stranissimo per creare una lista ma okay dart...
    List<LatLng> list = [
    for(CoordPoint point in _points)
      point.toLatLng()
    ];
    return list;
  }

  CoordPoint getMiddlePoint(){
    if(_points.isEmpty){
      return new CoordPoint(0, 0, 0, 0, new DateTime(0,0,0,0,0,0,0,0));
    }
    return this._points[_points.length~/2];
  }

  void setName(String name){
    this._name = name;
  }

  void addPoint(CoordPoint point){
    this._points.add(point);
  }


}