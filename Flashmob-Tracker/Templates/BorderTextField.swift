//
//  BorderedTextField.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct BorderTextField: View {
    
    @State private var showAlert: Bool = false
    
    private var placeholder: String
    private var bindValue: Binding<String>
    private var validationCheck: (() -> Bool)
    private var toolTipLocalKey: String
    private var keyboardType: UIKeyboardType = .default
    
    
    init( _ bindValue: Binding<String>, _ placeholder: String,
          _ toolTipLocalKey: String = "", _ keyboardType: UIKeyboardType = .default,
          _ validationCheck: @escaping () -> Bool) {
        
        self.bindValue = bindValue
        self.placeholder = placeholder
        self.toolTipLocalKey = toolTipLocalKey
        self.keyboardType = keyboardType
        self.validationCheck = validationCheck
    }
    
    var body: some View {
        
        ZStack(alignment: .trailing) {
            
            TextField(appLang.localString(self.placeholder),
                      text: self.bindValue,
                      axis: .vertical)
                .autocapitalization(.none)
                .keyboardType(self.keyboardType)
                .borderTextFieldStyle()

            Image(systemName: self.validationCheck() ?
                    "checkmark.circle":
                    "exclamationmark.circle" )
                .foregroundStyle(self.validationCheck() ?
                                    (self.colorScheme == .light ? Color.gray.opacity(0.9) :
                                        Color.white.opacity(0.3)) :
                                    .red)
                .font(.system(size: 22))
                .padding(.trailing, 8)
                .onTapGesture {
                    
                    if !self.toolTipLocalKey.isEmpty { showAlert = true }
                }
        }
        //.frame(height: 50)
        .alert(isPresented: $showAlert, content: {
            
            Alert(title: Text(appLang.localString("title_tip")),
                  message: Text(appLang.localString(self.toolTipLocalKey)),
                  dismissButton:
                    .default(Text(self.appLang.localString("btn_continue"))))
        })
    }
}
