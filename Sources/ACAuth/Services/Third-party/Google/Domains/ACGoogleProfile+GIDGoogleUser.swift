//
//  File.swift
//  
//
//  Created by Damian on 04.09.2023.
//

import GoogleSignIn

extension ACGoogleProfile {
    init(user: GIDGoogleUser) {
        self.id = user.userID
        self.idToken = user.idToken?.tokenString
        self.accessToken = user.accessToken.tokenString
        self.email = user.profile?.email
        self.name = user.profile?.name
        self.familyName = user.profile?.familyName
        self.givenName = user.profile?.givenName
    }
}
