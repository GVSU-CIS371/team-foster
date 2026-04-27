//
//  CreatePet.swift
//  petProject
//
//  Created by Aaron Foster on 3/20/26.
//

import SwiftUI


struct CreatePetView: View {
    @EnvironmentObject var vm: PetViewModel
    @State private var petName: String = ""
    @State private var petType: PetType? = nil
    @State private var selectedType: PetType? = nil
    @State private var currentIndex: Int = 0
    @State private var currentKey: String = ""
    private var userID: String {
        vm.player?.id ?? ""
    }
    
    private var onPetCreated: (String, String) -> Void
    
    init(onPetCreated: @escaping (String, String) -> Void){
        self.onPetCreated = onPetCreated
    }
    
    var body: some View {
        VStack{
            Text("New Pet")
            Spacer()
            
            VStack(){
                if selectedType == nil {
                    let keys = Array(vm.petTypes.keys)
                    
                    ZStack{
                        VStack{
                            TabView(selection: $currentKey){
                                ForEach(keys, id: \.self){ key in
                                    if let type = vm.petTypes[key] {
                                        VStack{
                                            Text(type.name)
                                            Spacer()
                                            Text(type.image).font(Font.largeTitle.bold())
                                            Spacer()
                                        }.padding(.bottom, 16).padding(.horizontal, 16).frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .background(Color.blue).cornerRadius(10).tag(key)
                                    }
                                }
                            }.tabViewStyle(.page)
                        }
                        
                        
                        GeometryReader{geo in
                            HStack {
                                Color.clear.contentShape(Rectangle()).onTapGesture {
                                    print("left")
                                    currentIndex = currentIndex > 0 ? currentIndex - 1 : keys.count - 1
                                    petType = vm.petTypes[keys[currentIndex]]
                                    currentKey = petType!.id
                                }.frame(width: geo.size.width/2)
                                Spacer()
                            }
                        }
                        
                        GeometryReader{geo in
                            HStack {
                                Spacer()
                                ZStack{
                                    Color.clear.contentShape(Rectangle()).onTapGesture {
                                        print("right")
                                        currentIndex = currentIndex < keys.count - 1 ? currentIndex + 1 : 0
                                        petType = vm.petTypes[keys[currentIndex]]
                                        currentKey = petType!.id
                                    }.frame(width: geo.size.width/2)
                                }
                            }
                        }
                    }
                } else {
                    VStack{
                        Text("Pet Name")
                        TextField("Enter...", text: $petName)
                    }
                }
            }
            Spacer()

            HStack{
                if selectedType != nil {
                    Button("Back"){
                        selectedType = nil
                    }
                }
                
                Button("Confirm"){
                    if selectedType != nil && petName != "" {
                        Task{@MainActor in
                            await vm.newPet(name: petName, typeID: petType!.id)
                        }
                    }
                    else{
                        print("TYPE SELECTED")
                        selectedType = vm.petTypes[currentKey]
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                print("CREATE PET VIEW")
                print(ObjectIdentifier(vm.player!))

                
                if petType == nil {
                    Task{ @MainActor in
                        let type = vm.petTypes.first!.value
                        petType = vm.petTypes[type.id]
                        currentKey = petType!.id
                    }
                }
            }.onChange(of: vm.player?.pet?.id) {
                print("PET CREATED ON CHANGE")
                if vm.player?.pet != nil {
                    self.onPetCreated(petName, selectedType?.id ?? "")
                }
            }
    }
}
