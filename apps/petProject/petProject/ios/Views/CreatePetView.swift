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
    @State private var currentIndex: Int = 0
    @State private var currentKey: String = ""
    private var userID: String {
        vm.player?.id ?? ""
    }

    
    private var onPetCreated: (String, String) -> Void
    
    init(onPetCreated: @escaping (String, String) -> Void){
        print("CREATE PET VIEW")

        self.onPetCreated = onPetCreated
    }
    
    var body: some View {
        VStack{
            Text("New Pet")
            Spacer()
            
            let keys = Array(vm.petTypes.keys)

            ZStack{
                VStack{
                    TabView(selection: $currentKey){
                        ForEach(keys, id: \.self){ key in
                            if let type = vm.petTypes[key] {
                                VStack{
                                    Text(type.name)
                                    Spacer()
                                    Text(type.image).font(.system(size: 300))
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
            
            Text("Pet Name")
            TextField("Enter...", text: $petName)
            
            Spacer()
            
            HStack{
                Button("Confirm"){
                    if petType != nil && petName != "" {
                        self.onPetCreated(petName, petType?.id ?? "")
                    }
                }
            }
            Spacer()
        }.navigationBarBackButtonHidden(true)
         .onAppear{
             print("CREATE PET VIEW")
             print(ObjectIdentifier(vm.player!))

             
             if petType == nil {
                 Task{ @MainActor in
                     let type = vm.petTypes.first!.value
                     petType = vm.petTypes[type.id]
                 }
             }
        }
    }
}
