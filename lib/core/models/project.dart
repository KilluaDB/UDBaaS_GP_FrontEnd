class Project {
  String name;
  String DBType;
  int id = 1;

  String providerType;
  Project({
    required this.DBType,
    required this.name,
    required this.providerType,
    this.id=1
  });
  
}
