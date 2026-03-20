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
    
    private var onPetCreated: () -> Void
    
    init(vm: PetViewModel, onPetCreated: @escaping () -> Void){
        self._vm = ObservedObject(wrappedValue: vm)
        self.onPetCreated = onPetCreated
    }
    
    var body: some View {
        VStack{
            Text("New Pet")
            Spacer()
            
            if petType == nil {
                ZStack{
                    VStack{
                        TabView(selection: $currentIndex){
                            ForEach(vm.petTypes.enumerated(), id: \.element.id){ index, type in
                                VStack{
                                    Text(type.name)
                                    Spacer()
                                    Text(type.image)
                                }.padding(.bottom, 16).padding(.horizontal, 16).frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.blue).cornerRadius(10).tag(index)
                                
                            }
                        }.tabViewStyle(.page)
                    }
                    
                    HStack {
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                            else if currentIndex < 0 {
                                currentIndex = vm.petTypes.count - 1
                            }
                        }
                    }
                    
                    HStack {
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            if currentIndex < vm.petTypes.count - 1 {
                                currentIndex += 1
                            }
                            else if currentIndex >= vm.petTypes.count - 1 {
                                currentIndex = 0
                            }
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
                        vm.newPet(name: petName, type: petType!)
                        
                        self.onPetCreated()
                    }
                    else{
                        petType = vm.petTypes[currentIndex]
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}
