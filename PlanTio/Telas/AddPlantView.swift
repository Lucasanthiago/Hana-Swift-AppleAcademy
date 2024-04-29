//
//  AddPlantView.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI

struct AddPlantView: View {
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var type: String = ""
    @State private var wateringTime: Date = Date()
    @State private var sunTime: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("Nome", text: $name)
                TextField("Tipo", text: $type)
                DatePicker("Horário para Regar", selection: $wateringTime, displayedComponents: .hourAndMinute)
                DatePicker("Horário para Tomar Sol", selection: $sunTime, displayedComponents: .hourAndMinute)
                HStack {
                    Spacer()
                    Button("Salvar") {
                        viewModel.addPlant(name: name, type: type, wateringTime: wateringTime, sunTime: sunTime)
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()

                }
                
            
            }
            .navigationBarTitle("Adicionar Planta", displayMode: .inline)
        }
    }
}
