import 'package:googleapis_auth/auth_io.dart';

class get_server_key {
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "road-mate-d732c",
          "private_key_id": "41e48ad74ef7cc6a7fa7c4444f2c5db81b5e9902",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDRj8eV0TQdfFvP\nv/Ruo+Nl0LEOMkw2qoY83ZSCw1INAN05gJ3umwRQu1FOqciE5KXHzb9+EiP9wiUC\nSrawY1XTXdzHSEYewwT9ABRVKtiwHuKR3nHK2aY+/m2bPDX/avFsUiNbyxeuWxHz\numhESCi/NEOepMyRd2/KhmhyGbpyi3PjuXo8MsJw6eZa6xyWRc5pNY9s8fj0gh8a\nToO29y+NSeVH3A9bVGc6oIideO/FpscnrEvtHo2yxDN4kVR7Qd4PmHLs6YPEXfmu\nrxLHUVsUnJLQsnWv8IgnGEQ6ei3mAi2u1AvWxxN5pV6Ex8WpW5B+WU1fwyw8YPFv\n1mWHF/YDAgMBAAECggEAH9Q4ujaWNcxHnZxIIe3egf5ahg95p+vqi6AUCHBmK/dv\nomY4lp8Q3ro0tT/wZs7bpydG6H0U3lv4hwqWCOBtjrb464O8srtoLI0wiWcClm16\neDFTEz5Pk83NFADnKq4xkQRAvpZwOFk4ts4fPA/BsJjdlGDveUCsyBP2FS53NSJW\nsLfVG5reiK6soWgjOngFbRUa1m3mEdqFI/cfY/LCbugpyXYZKIn3zqiKOyhbZU2U\nsf6ML3yohBwScnLq+cob+KGSGzcZ178FBlHESjVG4GsNYCNzo3tChWwSFnh5OVR6\nV0IJZcwGsibv1MNqsq9QD6IqreSRgPuW1NJMKnurAQKBgQD2EZFjwncBG5ORR1iP\nNX3Cz98e+2e1yg8aTBEYFnJzKs18YxEiVncDAsA13o2RyF06ohsISOVa+Hq/TPaD\nHNzSN+WbvQwSLY/6spD2UCsKNY+zWR8iW8AnTJopVm4VU/riLgoKKtl96kocUHIr\n+KH9AHoHE++88O13OBqr0eD5wwKBgQDaBQOSgO9k3KLI6Nw+nO4ccRm+/8t4nWUa\n9lqM09kvWqb7PZNBaPuglrdoguC0ng2S6SsOGFh4tpGAjZuarGVpl6v7BKCRJj07\nzMaM6BBtbSvk/druVbV/B3wCPR77J1tMpDgdjfSRIcEnq7zzSlB40ryZKLbM0WpT\nlAhxhbEOwQKBgC7gd+ceU9d1Lm6dveRCV3v2Z9YaJM6/+JKU7Si+lf0UqWLJ6Ki2\n+iMrsfxRMn0UQ5Z47Vdts6vZ7GBnRAsEQ5kUpvw9ToBkB6rFu9IAwcJHI+IR11mP\nSxLxh+jaG0ya3A+cn7MCKL7RFF9CgA2aZxmwro6MoL5I06RDnukeqZJLAoGBAJIx\njoWs49p0gMvMKfPqc1irFqKXEC+fC28bBvksDZTNau9KCPZxmVnD9tSj/l3fJib/\nJ5naBWlcsxDK5C7Br3cw92fpYGo0hBcXZ4SREILwE+EHwMjUvFGkCSnPJnkvmO85\np09aI0c2pTke1iMmD/QVC9aAEKQjQPMubsMA7QuBAoGADDgV1veSSJqfllem1HkD\nJkQTrk4jaP9RPl+MCg2f9zzw4pi4M+b0smf1XTH5PzbFMDAoxrGiUWMP6tHcqPR/\nk7IveXnMwk/7yPDFazGHUKiquIcQUWyqtEFLmwgcPyBoTLOH3vgKnoiVmMYUqVgg\nO3v1dzKXfGUNtOBpSlEdsXw=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-a8bod@road-mate-d732c.iam.gserviceaccount.com",
          "client_id": "115454806279067627084",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-a8bod%40road-mate-d732c.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}
