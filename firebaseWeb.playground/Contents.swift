import UIKit

//URL of which firebase url wanted to change
let url = URL(string: "https://test-c3a35-default-rtdb.firebaseio.com/patrick91026/macBook2.json")!

let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
    guard let data = data else { return }
    let a = (String(data: data, encoding: .utf8)!)
    print(a)
}
task.resume()
func firebasePUT (Url: String, itemS: String = "", itemI: Int = 0) {
    
    var R = true
    while R {
        let url = URL(string: Url)!
        struct UpdateUserResponse: Decodable {
            let battery: Int
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if (itemS == ""){
            let data = try? encoder.encode(itemI)
            request.httpBody = data
        }
        else if itemI == 0 {
            let data = try? encoder.encode(itemS)
            request.httpBody = data
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            
            if Int(httpResponse!.statusCode) == 200{
                R = false
            }
        }.resume()
        sleep(1)
    }
}
let urlNewEmail = "https://test-c3a35-default-rtdb.firebaseio.com/" + "patr" + "/email.json"
firebasePUT(Url: urlNewEmail, itemS: "a123@com.com" )

struct UpdateUserResponse: Decodable {
    let battery: Int
}

var request = URLRequest(url: url)
request.httpMethod = "PUT"
request.setValue("json", forHTTPHeaderField: "Content-Type")
let encoder = JSONEncoder()
let data = try? encoder.encode(30)
request.httpBody = data
URLSession.shared.dataTask(with: request) { (data, response, error) in
    let httpResponse = response as? HTTPURLResponse
    print(Int(httpResponse!.statusCode))
//    if (
}.resume()


