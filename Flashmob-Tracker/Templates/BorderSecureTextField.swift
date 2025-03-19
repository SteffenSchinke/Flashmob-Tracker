//
//  BorderedSecureTextField.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct BorderSecureTextField: View {
    
    @State private var showPassword: Bool = false
    @State private var showAlert: Bool = false
    
    private var placeholder: String
    private var bindValue: Binding<String>
    private var validationCheck: (() -> Bool)
    private var toolTipLocalKey: String
    
    
    init( _ bindValue: Binding<String>, _ placeholder: String,
          _ toolTipLocalKey: String = "", _ validationCheck: @escaping () -> Bool) {
        
        self.placeholder = placeholder
        self.bindValue = bindValue
        self.validationCheck = validationCheck
        self.toolTipLocalKey = toolTipLocalKey
    }
    
    var body: some View {
        
        ZStack(alignment: .trailing) {
            
            if showPassword {
                
                TextField(appLang.localString(self.placeholder), text: self.bindValue)
                    .autocapitalization(.none)
                    .borderTextFieldStyle()
            } else {
                
                SecureField(appLang.localString(self.placeholder), text: self.bindValue)
                    .autocapitalization(.none)
                    .borderTextFieldStyle()
            }
            
            HStack {
                Image(systemName: showPassword ?  "eye.slash": "eye" )
                    .foregroundStyle(self.colorScheme == .light ? Color.gray.opacity(0.8) : Color.white.opacity(0.3))
                    .font(.system(size: 19))
                    .onTapGesture { showPassword.toggle() }
                    .padding(.trailing, -6)
                
                Image(systemName: self.validationCheck() ?  "checkmark.circle": "exclamationmark.circle" )
                    .foregroundStyle(self.validationCheck() ?
                                     (self.colorScheme == .light ? Color.gray.opacity(0.9) :
                                        Color.white.opacity(0.3)) : .red)
                    .font(.system(size: 22))
                    .onTapGesture {
                        
                        if !self.toolTipLocalKey.isEmpty { showAlert = true }
                    }
            }
            .padding(.trailing, 8)
        }
        .frame(height: 50)
        .alert(
            isPresented: $showAlert,
            content: {
            
                Alert(title: Text(appLang.localString("title_tip")),
                      message: Text(appLang.localString(self.toolTipLocalKey)),
                      dismissButton:
                        .default(Text(self.appLang.localString("btn_continue"))))
        })
    }
}
