//
//  HomeViewModel.swift
//  Vollmed
//
//  Created by ALURA on 06/10/23.
//

import Foundation

struct HomeViewModel {
    
    // MARK: - Attributes
    
    let service: HomeServiceable
    let authService: AuthenticationServiceable
    var authManager = AuthenticationManager.shared
    
    // MARK: - Init
    
    init(service: HomeServiceable, authService: AuthenticationServiceable) {
        self.service = service
        self.authService = authService
    }
    
    // MARK: - Class methods
    
    func getSpecialists() async throws -> [Specialist]? {
        let result = try await service.getAllSpecialists()
        
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func logout() async {
        let result = await authService.logout()
        
        switch result {
        case .success(_ ):
            authManager.removeToken()
            authManager.removePatientID()
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
