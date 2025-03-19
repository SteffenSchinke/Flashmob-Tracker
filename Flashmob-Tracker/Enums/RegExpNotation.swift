//
//  RegExpNotation.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 19.02.25.
//


enum RegExpNotation: String {
    
    /// Website address
    case website = #"^(https?:\/\/)?(www\.)?([a-zA-Z0-9-]+\.[a-zA-Z]{2,})(\/[^\s]*)?$"#
    /// Pwd
    case password = #"^(?=.*\p{Lu})(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[\p{L}\d!@#$%^&*(),.?":{}|<>]{8,30}$"#
    /// Name ("Tom Bambus || Tom Bambus-Baum")
    case name = #"^[\p{Lu}][\p{L}0-9 \-]{3, 50}$"#
    /// ZipCode
    case zipCode = #"^[A-Za-z0-9][A-Za-z0-9 \-]{2,10}$"#
    /// Email
    case email = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,50}$"#
    /// Street
    case street = #"^[\p{L}0-9\s\-,.'°/]{3,} \d+[a-zA-Z]?$"#
    /// City
    case city = #"^[\p{L}\s\-'’]{3,}$"#
    /// Company
    case company = #"^[\p{L}0-9\s\-&.,'’()/]{3,}$"#
    /// Text - Set
    case text = #"^(?:[A-Z0-9][\p{L}0-9.\s,"'!&-]{4,})$"#

    
    
    func checkValue( _ value: String) -> Bool {
        
        if let regex = try? Regex(self.rawValue),
           value.firstMatch(of: regex) != nil {
            
            true
        } else {
            
            false
        }
    }
}
