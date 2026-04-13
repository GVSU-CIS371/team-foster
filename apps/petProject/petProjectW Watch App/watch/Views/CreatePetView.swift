//
//  CreatePet.swift
//  petProject
//
//  Created by Aaron Foster on 3/20/26.
//

import SwiftUI


struct CreatePetView: View {
    @ObservedObject var vm: PetViewModel
    @State private var petName: String = ""
    @State private var petType: PetType? = nil
    @State private var currentIndex: Int = 0
    @State private var currentKey: String = ""
    
    private var onPetCreated: () -> Void
    
    init(vm: PetViewModel, onPetCreated: @escaping () -> Void){
        self._vm = ObservedObject(wrappedValue: vm)
        self.onPetCreated = onPetCreated
        self._petType = .init(initialValue: vm.petTypes.first?.value)
    }
    
    var body: some View {
        VStack{
            Text("New Pet")
            Spacer()
            
            if petType == nil {
                ZStack{
                    let keys = Array(vm.petTypes.keys)
                    
                    VStack{
                        TabView(selection: $currentKey){
                            ForEach(keys, id: \.self){ key in
                                if let type = vm.petTypes[key] {
                                    VStack{
                                        Text(type.name)
                                        Spacer()
                                        Text(type.image)
                                    }.padding(.bottom, 16).padding(.horizontal, 16).frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(Color.blue).cornerRadius(10).tag(key)
                                }
                            }
                        }.tabViewStyle(.page)
                    }
                    
                    HStack {
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                                guard let currentIndex = keys.firstIndex(of: currentKey) else {return}
                                let prevIndex = currentIndex > 0 ? currentIndex - 1 : keys.count - 1
                                currentKey = keys[prevIndex]
                            }
                        }
                    
                    
                    HStack {
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            guard let currentIndex = keys.firstIndex(of: currentKey) else {return}
                            let nextIndex = currentIndex < keys.count - 1 ? currentIndex + 1 : 0
                            currentKey = keys[nextIndex]
                        }
                    }
                }
            }
            else {
                VStack{
                    Text("Pet Name")
                    TextField("Enter...", text: $petName)
                }
            }
            
            Spacer()

            HStack{
                if petType != nil {
                    Button("Back"){
                        petType = nil
                    }
                }
                
                Button("Confirm"){
                    if petType != nil && petName != "" {
                        //await vm.newPet(name: petName, typeID: petType!.id)
                        
                        self.onPetCreated()
                    }
                    else{
                        petType = vm.petTypes[currentKey]
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}
