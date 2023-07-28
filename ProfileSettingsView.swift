//
//  ProfileSettingsView.swift
//  Jointwise
//
//  Created by Biagio Marra on 20/04/23.
//

import SwiftUI
import CareKitStore


struct ProfileSettingsView: View {
    
    
    @Binding var name: String
    @Binding var surname: String
    @Binding var sex: String
    @Binding var birthDay: Date
    @EnvironmentObject var storeManagerWrapper: StoreManagerWrapper
    
        @Binding var isPresented: Bool
        
        @State private var tempNome: String
        @State private var tempCognome: String
        @State private var tempSesso: String
        @State private var tempCompleanno: Date
        
    init(Nome: Binding<String>, Cognome: Binding<String>, Sesso: Binding<String>, Compleanno: Binding<Date>, isPresented: Binding<Bool>) {
        _name = Nome
        _surname = Cognome
        _sex = Sesso
        _birthDay = Compleanno
            _isPresented = isPresented
        _tempNome = State(initialValue: Nome.wrappedValue)
        _tempCognome = State(initialValue: Cognome.wrappedValue)
        _tempSesso = State(initialValue: Sesso.wrappedValue)
        _tempCompleanno = State(initialValue: Compleanno.wrappedValue)
        
        }
    
    
    
    

    var body: some View {
        NavigationView {
            Form {
                
                SwiftUI.Section{
                    TextField("First Name", text: $name)
                        .padding(.vertical, 8)
                    TextField("Last Name", text: $surname)
                        .padding(.vertical, 8)
                } header:{
                    Text("Name")
                }

                SwiftUI.Section {
                    Picker(selection: $sex, label: Text("Sex")) {
                        Text("Male").tag("M")
                        Text("Female").tag("F")
                    }
                    .padding(.vertical, 8)

                    DatePicker(selection: $birthDay, displayedComponents: .date) {
                        Text("Birth Date")
                    }
                    .padding(.vertical, 8)
                } header: {
                     Text("Personal Info")
                }
                
                
                SwiftUI.Section {
                    Button(action: {

                        let storeManager = storeManagerWrapper.storeManager
                        let patientID = "patientId"
                        storeManager.store.fetchAnyPatient(withID: patientID, callbackQueue: .main) { result in
                            switch result {
                            case .success(let patiente):
                                
                                var updatedPatient = OCKPatient(id: patiente.id, givenName: name, familyName: surname)
                                updatedPatient.birthday = birthDay
                                updatedPatient.sex = OCKBiologicalSex(rawValue: sex)
                                storeManager.store.updateAnyPatient(updatedPatient, callbackQueue: .main) { result in
                                    switch result {
                                    case .success(let updatedPatient):
                                        print("Patient updated successfully: \(updatedPatient)")
                                        print(updatedPatient)
                                    case .failure(let error):
                                        print("Failed to update patient: \(error)")
                                    }
                                }
                            case .failure(let error):
                                print("Failed to fetch patient with ID \(patientID): \(error)")
                            }
                        }
                        self.isPresented = false
                                        }) {
                                            Text("Save")
                                                .foregroundColor(.green)
                                                .font(.headline)
                                        }

                    Button(action: {
                        // Ripristina i valori originali
                        name=tempNome
                        surname=tempCognome
                        sex=tempSesso
                        birthDay=tempCompleanno
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .font(.headline)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationBarTitle("Profile Settings")
        }
        .accentColor(.green)
        .onAppear {
            // Salva i valori originali nelle variabili temporanee quando la vista viene caricata
            tempNome = name
            tempCognome = surname
            tempSesso = sex
            tempCompleanno = birthDay
        }
    }
}
