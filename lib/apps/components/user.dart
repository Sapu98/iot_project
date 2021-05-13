class User{
  int id;
  String username;
  String email;
  bool activated;

  User(int id, bool activated, String username, String email){
    this.id = id;
    this.username = username;
    this.email = email;
    this.activated = activated;
  }
}