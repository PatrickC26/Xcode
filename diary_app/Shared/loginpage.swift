//
//  loginpage.swift
//  diary_app
//
//  Created by 陳彥儒 on 2022/1/23.
//
import SwiftUI
import Firebase
import GoogleSignIn

struct loginPage: View {
    @AppStorage ("userid") var userid: String = ""
    @AppStorage ("currentPage") var currentPage = 0
    @AppStorage ("anonymous") var anonymous = false
    @AppStorage ("dosync") var dosync = true

    
    @State var anonymousWarning = false
    var body: some View {
        
        VStack{
            
            Text("Diary")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.orange)
                .lineLimit(7)
                .fixedSize()
            HStack{
                Text("Put all your secret in here  ")
                    .multilineTextAlignment(.trailing)
                    .padding(.vertical)
            }
            .padding()
            
            Button{
                loginviagoogle()
            }label :{
                HStack(spacing: 15){
                    Image("google").resizable().frame(width: 28, height: 28)
                    Text("Log in / Sign in with google")
                }
                .padding()
                .frame(maxWidth: UIScreen.main.fixedCoordinateSpace.bounds.width-40)
                .background(
                    Color.clear.border(Color.blue)
                )
            }
            
            Button{
                anonymousWarning = true
            }label :{
                HStack(spacing: 15){
                    Text("Log in Anonymous")
                }
                .padding()
                .frame(maxWidth: UIScreen.main.fixedCoordinateSpace.bounds.width-40)
                .background(
                    Color.clear.border(Color.blue)
                )
            }
            .alert(isPresented: $anonymousWarning) {
                Alert(
                    title: Text("Log in with anonymous"),
                    message: Text("All data will be stored on phone and will not be back up"),
                    primaryButton: .default(
                        Text("Cancal"),
                        action: {
                            
                        }
                    ),
                    secondaryButton: .destructive(
                        Text("YES"),
                        action: {
                            anonymous = true
                            currentPage = 1
                            dosync = false
                        }
                    )
            )}
        }
    }
    
    
    func loginviagoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewControl()){ user , err in
            if let error = err {
                print (error.localizedDescription)
                return
            }

            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: authentication.accessToken)

            //Firebase auth
            Auth.auth().signIn(with: credential) { result, err in
                if let error = err {
                    print (error.localizedDescription)
                    return
                }
                
                
                guard let user = result?.user else {
                    return
                }
                userid = user.uid
                print(user.uid)
                if (Auth.auth().currentUser?.uid == userid){
                    let ada = DiaryDataFirebase()
                    ada.renew()
                    currentPage = 1
                }
            }
        }
    }
}

struct loginPage_Previews: PreviewProvider {
    static var previews: some View {
        loginPage()
        
    }
}


extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    
    func getRootViewControl()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
}
