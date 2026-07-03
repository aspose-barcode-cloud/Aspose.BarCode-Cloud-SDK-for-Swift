import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

struct TokenResponse: Decodable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

let clientId = "Client Id from https://dashboard.aspose.cloud/applications"
let clientSecret = "Client Secret from https://dashboard.aspose.cloud/applications"
let tokenURL = URL(string: "https://id.aspose.cloud/connect/token")!

var form = URLComponents()
form.queryItems = [
    URLQueryItem(name: "grant_type", value: "client_credentials"),
    URLQueryItem(name: "client_id", value: clientId),
    URLQueryItem(name: "client_secret", value: clientSecret),
]

var request = URLRequest(url: tokenURL)
request.httpMethod = "POST"
request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
request.httpBody = form.percentEncodedQuery?.data(using: .utf8)

let (data, response) = try await URLSession.shared.data(for: request)

guard let httpResponse = response as? HTTPURLResponse,
      200 ..< 300 ~= httpResponse.statusCode
else {
    throw NSError(domain: "AsposeBarcodeCloud", code: 1)
}

let token = try JSONDecoder().decode(TokenResponse.self, from: data)
print(token.accessToken)
