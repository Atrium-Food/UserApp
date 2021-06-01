import 'dart:convert';
import 'dart:io';

import 'package:flutter_restaurant/view/screens/chat_support/dialogflow_utils/chat_provider_dialogflow.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class GoogleAPIs {
  // static var accountCredentials = ServiceAccountCredentials.fromJson({
  //   "private_key_id": "1054076aa3d26f17cb6368e1d836edb0a1310773",
  //   "private_key":
  //       "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDN+3SR5RN59bX6\nxbD/992iu6YaYAjKJDgWK8qRAr59wIFEmEfxtG0lx5rLQ8Mc6KOYLIo04HorRCQT\ngVx1BEZwIJP8AYuc6vVt3KgUtBl7PBoMCnSIl6gMdRrk5GJhoNb+Ts2LKaOK1obD\niCNod60KpZPRt0DtQhhVLqqK3KXcuketgbgCcNlABtcIXIu4XsWXiBWux6H773IQ\neD1mfA8rZGvuiNdC3kRVFJQ+MCqg9diH7+kB/VSydNX5Q2UIhABm5FnP0pVSSv2b\nk2UXG+s+CCb+Gp4mRV7/UqGVg74BnCI2etYjDhjICZg+Nuv7v7zbNATjiiCTIvRE\nry0Y8U3jAgMBAAECggEAT+MR41GWe6sNwKwyiRvPREGF2t3bGtbwP70NK6+GRMxH\n9lwfLwF8gXYINYRa5FfftvGzSm2zRBuB6GS4AJQ/Y1ZnPoo05Q+FT24QbDMrXM3D\nBl95sc4ruWUjoJlpBJc2OtxCQJJOINcx3hzrKqWbobD1AxWRI1OKj2Lxdri7xT5x\nyOWLKRC6gpPfEcWeIh9/BQ3LBDp7lsBaU1LPtzsQYSFiUEYdegNXKPkZeeezqlMl\nQ6fOCkQmIhKohtqtbJyE+uMB9eg4Au2/gkR/d4bPafc0juT+ZHCCbVzRJ8cKVKuJ\njcNp7rp9eKs4YmoqS9v9QX8Y6HH8M7OQbQwf+bK+CQKBgQDrMz9RFnDxvz3H+T2U\nou271P0D0aPvZDT2CPLkUZeUZGcXY1jE+mJkoBqlgx6Sx5yot16LYQoNE1LQCj9J\nflE3xruF+SxFxsRjiwaml4NBMEiYS6XYVF0vwZqLuWTho7psAssuluFowJGvrN5k\nJBbhHVAM56rOcj40M+2bt3JXuQKBgQDgMrx4wL4LRmfHYv3zZSIk7uLgAhkRlSAf\nkD06e6mO9tpoJuNymoAaLj+MoaAkyJDNZ7g9rNpwTe5dKQ2Ac4rcVQD63hiPns4+\nP/zmvr5mHJFWcfDRtdulgBwkvW9RfAsDkL6wkL941tHVgWlnYC9duTlEiglx093l\nJhFKf05oewKBgQCCyJpaopnnMypNekBN2FNNcN/IMdhwk04HyW4Wm3AoKbRRgwKn\ndXsk7QokIsbrY2evQVenNSx7nNUdrbUHTuAmnbFEjAucOSyXFYV7OSDZLNoRJW9w\n3Wh717HyJAL+nSZaTStiGq/4qavY/c0j7hVy0/PhWSjXZxtDt+RWBCnmsQKBgGXG\nwoZywRMvP/dkufIfLBPmGjok2aqArxeFDDabYsrSxy1W0hP5jUPVUOYPjTqFji6g\n8iOVb4hh6F6EP2vbh+Mj95Dq9+1i4y+hLra1SoviVhwPF4qr6u1DrgMDuCAeloVk\n1Rwkabd6lcE9wVK7eGUsq5GwtD7nNilLUbgm+Lo3AoGBAMDYH+zYLJ49xrnP1tqW\nXgv7q21RKZuPoM2wJNsLzEmc8MC73WrWrAGraiseUqXjYYq6e0XTHg+SRqQEdKsn\n1lHI8tzKZ8V6kcFMCSIfVQZksLqBqwsn8JT+gqAxgChGObgHZJ3rVO1ZxeJMNVqU\nD/mfCgMofB93vdXXneOggwj4\n-----END PRIVATE KEY-----\n",
  //   "client_email": "atrium@atrium-315011.iam.gserviceaccount.com",
  //   "client_id": "114781911144895003370.apps.googleusercontent.com",
  //   "type": "service_account"
  // });
  static var accountCredentials = ServiceAccountCredentials.fromJson({
    "private_key_id": "69adeac62370f5b5703a87eaddd2501f8ec601d1",
    "private_key":
  "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCfz0OiurfjUm+2\nm2uLgV2UcmiFmiOSFcKgF0T7wDYaz/G0T3XI/aKaGEq0ZQ9g2jkZ68fi1n5z1739\nxJZNB7mNl/bdvJJP8bhscZSJ+HqXpIRF9BlaOFzcfbpnkhEloJFICpAQ8bBf7+pN\nvQTdPHpQ7Xm6e23D55UNSKQcx97h7klGx1SHuJyUbHGkxo9jqTbAGF+Egb0qoQGT\nglrhp2ytIjsG9QgUMz41xZ555bHtrs5VniUh5OP49DGCcRrVAbSsTKx9NU040BL8\nP6jH5o0BXZ27KE5Zg6lIXvNmrNWxqpKneRSjuSkNyjdURSLiGwPsnNneyPAD4ep4\nHMM5xShnAgMBAAECggEAI0fqSjBHrZ+C+0EHtqZKRx4U9j3n0XYNYDOS7rNqHnQ/\nC8wpGETqk3N+dqIDCaJTzeWwXON2ylNcZfxzJDFq5RgiD6T0dkLKsOJIZUdepUDU\nVO9Fc5YS5ji5oOjt8S0oNcvjL2J0SlHYm+35d3BFHr22zJU4T/I+BU8+r/3uNlmA\nM72CB9zEr0WeDNEA9gfRyKP9dO7fu5HhR71IUGQL9hOqOub+qIXov0LpVULbxhHc\nWWm+P2rcHfXNz6MUA9twMEdFkCNVdelNY3qYQtP1/mYHdzSVgh+LBX/qMoN6kSLe\n0x4oeJVemysyhz53Z0nv+NbjhMbTH2W7e7rPPY8hrQKBgQDKyIKRVi1Jo3OBO/Q7\nVWRioPrpzGgeF31FPDtg5asN1b5IK340g7/wdsKKiXAM3KoJwjdKN3guDch9mvUf\nW1inZ8J1DNCvZt1/YJJoEV+8Ri2SCb4pe0+qrCXv9dS9FIz7dw/di/98oKSws7MN\nLgF1wyECdNasOu4otrmJCFtGTQKBgQDJv62cKem6N9tFIvCSFsQDeGjuImW+xhvE\nc4qr2uj7G/EscuQVWUoU5wO0T6XVLTqMjY+uKCojRvUs0ssolhO+VSwvycPpmzm1\nXM/JVegf4JCldst5CGbFzdz+jL5r2e38kt4NquvXJZsfe73SHkXtIKp7/PBUQPhy\noVkf8mZrgwKBgFUgh29rtedL7pk6CfU+i727xpmPbcX0JmqCNose3wgXyqGRYJG7\nHUBdGp39xEQh/l/KYFuPnav3rUrNWkmnlzfvnvp0Psbjb+ihKdT2NjJbY5YC8QmI\n8pC7Y9GwaXZWwjhuawKeWsp+xaRIS8oknghJufnGAriapJAC5TBZibehAoGATACi\ntY7wlw+N0ijMeiyLYUdOOE/LBqh5M3PXjNBmLpsjKvyJQiWmC+PPeHD85ycnxGVb\n+F73KN0FZgJvOHX5MB3EDKi03l90yQcS3CU50jB2LW9oTctFdEUOePKqldS+nAT0\nFDAMsrtfCehC5VI0Q5WnxBfQrdzf+8ce3TMjNGMCgYEAl7m04d28j2guRs/LBL4Y\nq3sM39ii9RhX4p7MWmcdcCNyrqf9UzD+aP0FmDj+hQpuZ/J2/nus64VRmgxbzmYK\nLvoZH/7gG+6h0tUSqUhSo0mHXDznvKbmxc1qhGwR+h3jGTbhT4hjP2O5gpbSLkcD\n2kI9s5iRklY0/C+iX0/E8P0=\n-----END PRIVATE KEY-----\n",
  "client_email": "atriumservice@atrium-315506.iam.gserviceaccount.com",
    "client_id": "103933781867876724492.apps.googleusercontent.com",
    "type": "service_account"
  });
  static var scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/dialogflow"
  ];

  static String token;

  static createAuthCreds() async {
    var client = http.Client();
    print("Why");

    obtainAccessCredentialsViaServiceAccount(accountCredentials, scopes, client)
        .then((AccessCredentials creds) async {
         token= creds.accessToken.data;
         print("Token Created: $token");
      client.close();
    });
  }

  static Future sendMessage(String text) async {
    var client = http.Client();
    print("Token Use: $token");
    var resp=await client.post(
      Uri.parse(
          "https://dialogflow.googleapis.com/v2/projects/atrium-315506/agent/sessions/1234567:detectIntent"),
      body: jsonEncode({
        "query_input": {
          "text": {
            "text": text,
            "language_code": "en-US"}
        }
      }),headers: {
        'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }
    );
    print(resp.body);
    if(resp.statusCode==200){
      Map reply=jsonDecode(resp.body);
      print("Status 200 ${reply["queryResult"]["fulfillmentText"]}");
      return MessageModel(message: reply["queryResult"]["fulfillmentText"],sendTime: DateTime.now(),isUser: false);
    } else {
      return null;
    }

  }
}
