import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            // Background color
            Color(hex: "0E5C53")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Logo
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 120, height: 120)
                            .cornerRadius(10)
                        
                        Text("Mutqin")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(hex: "0E5C53"))
                    }
                    .padding(.top, 40)
                    
                    // Sign in text
                    Text("Sign in to your account")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // Login Form
                    VStack(alignment: .leading, spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                            
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.password)
                        }
                        
                        // Forgot Password
                        HStack {
                            Spacer()
                            Button(action: {
                                // Handle forgot password
                            }) {
                                Text("Forgot Password?")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                            }
                        }
                        .padding(.top, 8)
                        
                        // Login Button
                        Button(action: {
                            // Handle login
                        }) {
                            Text("Login")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(hex: "0E5C53"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 16)
                        
                        // Or continue with
                        HStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 1)
                            Text("Or continue with")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 14))
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 24)
                        
                        // Social Login Buttons
                        HStack(spacing: 16) {
                            // Google Button
                            Button(action: {
                                // Handle Google sign in
                            }) {
                                HStack {
                                    Image(systemName: "g.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("Google")
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            
                            // Apple Button
                            Button(action: {
                                // Handle Apple sign in
                            }) {
                                HStack {
                                    Image(systemName: "apple.logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                    Text("Apple")
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                        }
                        
                        // Sign Up Link
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.white.opacity(0.7))
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(dismiss: dismiss))
    }
}

// Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
    }
}

// Custom Back Button
struct BackButton: View {
    let dismiss: DismissAction
    
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .imageScale(.large)
                .frame(width: 44, height: 44)
        }
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
} 