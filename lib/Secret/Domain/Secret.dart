class Secret {

  Secret({required this.secretId, this.userId = "", this.secret = "", this.uris = const []});

  int secretId;
  String userId = "";
  String secret = "";
  List<String> uris = [];

  Map toJson() {

    return {
      'secretId': secretId,
      'userId' : userId,
      'secret' : secret,
      'uris' : uris
    };

  }

}