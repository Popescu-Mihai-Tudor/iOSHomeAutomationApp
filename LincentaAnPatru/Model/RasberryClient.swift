//
//  RasberryClient.swift
//  LincentaAnPatru
//
//  Created by Mihai on 25.02.2024.
//

import Foundation

class RaspberryClient: ObservableObject {
    let raspberryPiAddress = "192.168.0.179"
    let port = "5000"
    
    private var session: URLSession?
    @Published var canCheckConnection: Bool = true
    @Published var showAlert: Bool = false
    
    // Function to create a URLSession
    private func createURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration)
        print("CREATED URL SESSION")
        return session
    }
    
    func selectLedToToggle(ledToToggle: Int) -> [String : Int] {
        return ["led_to_toggle": ledToToggle]
    }
    
    // Function to send a message to the Raspberry Pi server
    func sendMessage(ledToToggle: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "http://\(raspberryPiAddress):\(port)/api/toggleLed")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dataToSend = selectLedToToggle(ledToToggle: ledToToggle)
        
        do {
            if let jsonData = try? JSONSerialization.data(withJSONObject: dataToSend, options: []) {
                request.setValue("\(jsonData.count)", forHTTPHeaderField: "Content-Length")
                request.httpBody = jsonData
                print("Raw Data: \(String(data: jsonData, encoding: .utf8) ?? "")")
            } else {
                print("Error encoding JSON")
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if session == nil {
                session = createURLSession()
            }
            
            let task = session?.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data,
                      let responseString = String(data: data, encoding: .utf8) else {
                    let error = NSError(domain: "SwiftErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                    completion(.failure(error))
                    return
                }
                
                completion(.success(responseString))
                print("RECEIVED MESSAGE: \(responseString)")
            }
            
            request.httpBody?.count // Access the body to trigger flushing
            request.httpBody = nil // Set to nil to close the request
            
            task?.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func checkConnection() {
        canCheckConnection = false
        let url = URL(string: "http://\(raspberryPiAddress):\(port)/api/checkConnection")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            if session == nil {
                session = createURLSession()
            }
            
            let task = session?.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("ERROR \(error)")
                    return
                }
                
                guard let data = data,
                      let responseString = String(data: data, encoding: .utf8) else {
                    let error = NSError(domain: "SwiftErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                    return
                }
                
                print("RECEIVED MESSAGE: \(responseString)")
                DispatchQueue.main.sync {
                    self.showAlert.toggle()
                    self.canCheckConnection = true
                }
            }
            
            request.httpBody?.count // Access the body to trigger flushing
            request.httpBody = nil // Set to nil to close the request
            
            task?.resume()
        } catch {
            DispatchQueue.main.sync {
                self.canCheckConnection = true
            }
        }
    }
}
