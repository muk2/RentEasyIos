import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var responseText: String = ""
    @State private var statusCode: Int? = nil
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("RentEasy API Test")
                .font(.title)
                .bold()

            TextField("Enter search term...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                fetchSearch()
            }) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Search")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .disabled(searchText.isEmpty || isLoading)
            .padding(.horizontal)

            if let status = statusCode {
                Text("Status: \(status)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text(responseText)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(white: 0.95))
                .cornerRadius(8)
                .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
    }

    func fetchSearch() {
        guard let url = URL(string: "http://localhost:8080/arey/\(searchText)") else {
            responseText = "Invalid URL"
            return
        }

        isLoading = true
        responseText = ""
        statusCode = nil

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    responseText = "Error: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }

                if let data = data, let text = String(data: data, encoding: .utf8) {
                    responseText = text
                } else {
                    responseText = "No response data"
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
