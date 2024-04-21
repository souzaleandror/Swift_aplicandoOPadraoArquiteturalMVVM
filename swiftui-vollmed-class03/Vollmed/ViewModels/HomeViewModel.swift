//
//  HomeViewModel.swift
//  Vollmed
//
//  Created by Leandro Rodrigues on 18.04.2024.
//

import Foundation


struct HomeViewModel {
     // MARK: - Attributes
    
    let service = WebService()
    
    // Mark: - Class methods
    
    func getSpecialists() async throws -> [Specialist]{
        do {
            if let getchedSpecialists = try await service.getAllSpecialists() {
                return specialists
            }
            
            return []
        } catch {
            print("Ocorreu um erro ao obter os especialistas: \(error)")
            throw error
        }
    }
}
