import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var agreedToTerms = false
    
    // Validation states
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var showingErrors = false
    
    // Validation functions
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    private func validateForm() {
        // Reset errors
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        
        // Validate email
        if email.isEmpty {
            emailError = "Email is required"
        } else if !isValidEmail(email) {
            emailError = "Please enter a valid email address"
        }
        
        // Validate password
        if password.isEmpty {
            passwordError = "Password is required"
        } else if !isValidPassword(password) {
            passwordError = "Password must be at least 8 characters with 1 uppercase, 1 lowercase, and 1 number"
        }
        
        // Validate confirm password
        if confirmPassword.isEmpty {
            confirmPasswordError = "Please confirm your password"
        } else if password != confirmPassword {
            confirmPasswordError = "Passwords do not match"
        }
        
        showingErrors = true
    }
    
    // Computed property to check if form is valid
    private var isFormValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        isValidEmail(email) &&
        !password.isEmpty &&
        isValidPassword(password) &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        agreedToTerms
    }
    
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
                    
                    // Sign up text
                    Text("Start your Hifdh journey")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Text("Let's get you started")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 4)
                    
                    // Sign Up Form
                    VStack(alignment: .leading, spacing: 20) {
                        // Full Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                            
                            TextField("Enter your name", text: $fullName)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.name)
                                .autocapitalization(.words)
                        }
                        
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
                                .onChange(of: email) { _ in
                                    if showingErrors {
                                        validateForm()
                                    }
                                }
                            
                            if let error = emailError, showingErrors {
                                Text(error)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.top, 4)
                            }
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                            
                            SecureField("Create a password", text: $password)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.newPassword)
                                .onChange(of: password) { _ in
                                    if showingErrors {
                                        validateForm()
                                    }
                                }
                            
                            if let error = passwordError, showingErrors {
                                Text(error)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.top, 4)
                            }
                        }
                        
                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                            
                            SecureField("Confirm your password", text: $confirmPassword)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.newPassword)
                                .onChange(of: confirmPassword) { _ in
                                    if showingErrors {
                                        validateForm()
                                    }
                                }
                            
                            if let error = confirmPasswordError, showingErrors {
                                Text(error)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.top, 4)
                            }
                        }
                        
                        // Terms and Conditions
                        HStack(alignment: .top, spacing: 8) {
                            Button(action: {
                                agreedToTerms.toggle()
                            }) {
                                Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(agreedToTerms ? .white : .white.opacity(0.7))
                                    .font(.system(size: 20))
                            }
                            
                            Text("I agree to the ")
                                .foregroundColor(.white.opacity(0.7)) +
                            Text("Terms & Conditions")
                                .foregroundColor(.white)
                                .fontWeight(.medium) +
                            Text(" and ")
                                .foregroundColor(.white.opacity(0.7)) +
                            Text("Privacy Policy")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                        .font(.system(size: 14))
                        .padding(.top, 8)
                        
                        // Create Account Button
                        Button(action: {
                            validateForm()
                            if isFormValid {
                                // Handle sign up
                            }
                        }) {
                            Text("Create Account")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(hex: "0E5C53"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1 : 0.7)
                        .padding(.top, 16)
                        
                        // Login Link
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.white.opacity(0.7))
                            NavigationLink(destination: LoginView()) {
                                Text("Log in")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                        
                        // Quran Verse
                        Text("And We have certainly made the Quran easy to remember... – [Surah 54:17]")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .italic()
                            .padding(.top, 24)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(dismiss: dismiss))
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
        }
    }
} 
