import 'dart:convert';
import 'dart:io';

import 'package:flutter_restaurant/view/screens/chat_support/dialogflow_utils/chat_provider_dialogflow.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class GoogleAPIs {
  static var accountCredentials = ServiceAccountCredentials.fromJson({
    "private_key_id": "1054076aa3d26f17cb6368e1d836edb0a1310773",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDN+3SR5RN59bX6\nxbD/992iu6YaYAjKJDgWK8qRAr59wIFEmEfxtG0lx5rLQ8Mc6KOYLIo04HorRCQT\ngVx1BEZwIJP8AYuc6vVt3KgUtBl7PBoMCnSIl6gMdRrk5GJhoNb+Ts2LKaOK1obD\niCNod60KpZPRt0DtQhhVLqqK3KXcuketgbgCcNlABtcIXIu4XsWXiBWux6H773IQ\neD1mfA8rZGvuiNdC3kRVFJQ+MCqg9diH7+kB/VSydNX5Q2UIhABm5FnP0pVSSv2b\nk2UXG+s+CCb+Gp4mRV7/UqGVg74BnCI2etYjDhjICZg+Nuv7v7zbNATjiiCTIvRE\nry0Y8U3jAgMBAAECggEAT+MR41GWe6sNwKwyiRvPREGF2t3bGtbwP70NK6+GRMxH\n9lwfLwF8gXYINYRa5FfftvGzSm2zRBuB6GS4AJQ/Y1ZnPoo05Q+FT24QbDMrXM3D\nBl95sc4ruWUjoJlpBJc2OtxCQJJOINcx3hzrKqWbobD1AxWRI1OKj2Lxdri7xT5x\nyOWLKRC6gpPfEcWeIh9/BQ3LBDp7lsBaU1LPtzsQYSFiUEYdegNXKPkZeeezqlMl\nQ6fOCkQmIhKohtqtbJyE+uMB9eg4Au2/gkR/d4bPafc0juT+ZHCCbVzRJ8cKVKuJ\njcNp7rp9eKs4YmoqS9v9QX8Y6HH8M7OQbQwf+bK+CQKBgQDrMz9RFnDxvz3H+T2U\nou271P0D0aPvZDT2CPLkUZeUZGcXY1jE+mJkoBqlgx6Sx5yot16LYQoNE1LQCj9J\nflE3xruF+SxFxsRjiwaml4NBMEiYS6XYVF0vwZqLuWTho7psAssuluFowJGvrN5k\nJBbhHVAM56rOcj40M+2bt3JXuQKBgQDgMrx4wL4LRmfHYv3zZSIk7uLgAhkRlSAf\nkD06e6mO9tpoJuNymoAaLj+MoaAkyJDNZ7g9rNpwTe5dKQ2Ac4rcVQD63hiPns4+\nP/zmvr5mHJFWcfDRtdulgBwkvW9RfAsDkL6wkL941tHVgWlnYC9duTlEiglx093l\nJhFKf05oewKBgQCCyJpaopnnMypNekBN2FNNcN/IMdhwk04HyW4Wm3AoKbRRgwKn\ndXsk7QokIsbrY2evQVenNSx7nNUdrbUHTuAmnbFEjAucOSyXFYV7OSDZLNoRJW9w\n3Wh717HyJAL+nSZaTStiGq/4qavY/c0j7hVy0/PhWSjXZxtDt+RWBCnmsQKBgGXG\nwoZywRMvP/dkufIfLBPmGjok2aqArxeFDDabYsrSxy1W0hP5jUPVUOYPjTqFji6g\n8iOVb4hh6F6EP2vbh+Mj95Dq9+1i4y+hLra1SoviVhwPF4qr6u1DrgMDuCAeloVk\n1Rwkabd6lcE9wVK7eGUsq5GwtD7nNilLUbgm+Lo3AoGBAMDYH+zYLJ49xrnP1tqW\nXgv7q21RKZuPoM2wJNsLzEmc8MC73WrWrAGraiseUqXjYYq6e0XTHg+SRqQEdKsn\n1lHI8tzKZ8V6kcFMCSIfVQZksLqBqwsn8JT+gqAxgChGObgHZJ3rVO1ZxeJMNVqU\nD/mfCgMofB93vdXXneOggwj4\n-----END PRIVATE KEY-----\n",
    "client_email": "atrium@atrium-315011.iam.gserviceaccount.com",
    "client_id": "114781911144895003370.apps.googleusercontent.com",
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
          "https://dialogflow.googleapis.com/v2/projects/atrium-315011/agent/sessions/1234567:detectIntent"),
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
