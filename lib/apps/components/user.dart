class User{
  int _id;
  String _username;
  String _email;
  bool _activated;

  User(int id, bool activated, String username, String email){
    this._id = id;
    this._username = username;
    this._email = email;
    this._activated = activated;
  }

  int getId(){
    return this._id;
  }

  String getUsername(){
    return this._username;
  }

  String getEmail(){
    return this._email;
  }

  bool isActive(){
    return this._activated;
  }


}