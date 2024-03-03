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
    @Published var currentTemperature: String = ""
    @Published var currentHumidity: String = ""
    @Published var gatheringInformation: Bool = false
    
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
    
    func pollTemperature() {
        let url = URL(string: "http://\(raspberryPiAddress):\(port)/api/getTemperature")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        self.currentTemperature = ""
        self.currentHumidity = ""
        self.gatheringInformation = true
        
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
                // Attempt to parse the JSON data
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        print("Failed to parse JSON")
                        return
                    }
                    
                    // Check if the JSON contains the 'temperature' key
                    if let temperature = json["temperature"] as? Double {
                        print("Temperature is: \(temperature)")
                        self.currentTemperature = temperature.description
                    } else {
                        print("Temperature not found in JSON")
                    }
                    if let humidity = json["humidity"] as? Double {
                        print("Humidity is: \(humidity)")
                        self.currentHumidity = humidity.description
                    } else {
                        print("Humidity not found in JSON")
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
                
                
                print("RECEIVED MESSAGE: \(responseString)")
                self.gatheringInformation = false
            }
            
            request.httpBody?.count // Access the body to trigger flushing
            request.httpBody = nil // Set to nil to close the request
            
            task?.resume()
        } catch {
            self.gatheringInformation = false
        }
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
    
    
    //polling
    
    var timer: Timer?
    
    func startPolling() {
        // Create a timer that fires every 5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.pollTemperature()
        }
        // Immediately fire the timer (since it waits for the first interval before firing)
        timer?.fire()
    }
    
    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }
}
