import SwiftUI
import RealityKit
import ARKit

struct MosaicoDetailView: View {
    let mosaico: Mosaico
    @State private var selectedMode = 0
    @State private var showResumen = false
    @State private var currentManualColor: ColorInfo?
    @State private var showVistaPrevia = false
    @EnvironmentObject var favoritosManager: FavoritosManager

    
    
    let modes = ["Automático", "Manual"]

    @State private var selectedColors: [ColorInfo] = []
    @State private var showColorSheet = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Encabezado
            HStack {
                           Spacer()
                           Text(mosaico.nombre)
                               .font(.title3)
                               .fontWeight(.semibold)
                               .foregroundColor(.black)
                           Spacer()
                NavigationLink(
                    destination: VistaPreviaMosaicoView(mosaico: mosaico, selectedColors: selectedColors)
                ) {
                    Image(systemName: "eye")
                        .foregroundColor(.black)
                        .padding(.trailing, 30)
                }

                       }
            .padding(.bottom, 10)

            // Picker
            HStack(spacing: 0) {
                // 🔁 Picker de modos (actualizado)
            
                    ForEach(0..<modes.count, id: \.self) { index in
                        Text(modes[index])
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selectedMode == index ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedMode == index ? .white : .black)
                            .onTapGesture {
                                if selectedMode != index {
                                    selectedColors = []

                                    selectedMode = index
                                    
                                    // ✅ Si se cambia a modo Manual, asignamos un color si hay
                                    if selectedMode == 1 {
                                        currentManualColor = selectedColors.first
                                        print("🎨 Asignando color manual: \(String(describing: currentManualColor?.name))")
                                    }
                                }
                            }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .padding(.bottom, 8)


            // ScrollView con AR y colores
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if selectedMode == 0 {
                        StaticARViewContainer(selectedColors: selectedColors, modelName: mosaico.nombre, isStatic: true)
                            .id(selectedColors.count)
                            .frame(height: UIScreen.main.bounds.height * 0.6)
                            .background(Color.white)
                    } else {
                        ManualARViewContainer(currentColor: $currentManualColor, modelName: mosaico.nombre)
                            .id(selectedColors.count)
                            .frame(height: UIScreen.main.bounds.height * 0.6)
                            .background(Color.white)
                    }

                    
                    // Botón para añadir color
                    Button(action: {
                        if selectedColors.count < 3 {
                            showColorSheet = true

                            // ✅ En modo manual, actualizar el color activo
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if selectedMode == 1 {
                                    currentManualColor = selectedColors.last
                                    print("🎨 Nuevo color manual asignado: \(String(describing: currentManualColor?.name))")
                                }
                            }
                        } else {
                            print("Ya has seleccionado 3 colores.")
                        }
                    }) {
                        Label("Añade color", systemImage: "plus")
                            .font(.subheadline.bold())
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.gray.opacity(0.9))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }



                    // 🪨 Imágenes de piedra agregadas
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(Array(selectedColors.enumerated()), id: \.element.id) { index, color in
                                ZStack(alignment: .topTrailing) {
                                    VStack(spacing: 4) {
                                        Image(color.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 80)
                                            .cornerRadius(8)

                                        Text(color.name)
                                            .font(.caption2)
                                            .foregroundColor(.black)

                                        Text(color.price)
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.bottom, 4)

                                    // Eliminar solo si no es el primero (o desde el segundo como pediste)
                                    if index == 0 {
                                        // ✏️ Botón para editar el primer color
                                        Button(action: {
                                            // Remueve el primer color y abre el sheet para elegir otro
                                            selectedColors.remove(at: 0)
                                            showColorSheet = true
                                        }) {
                                            Image(systemName: "pencil.circle.fill")
                                                .foregroundColor(.blue)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                        }
                                        .offset(x: 3, y: -1)
                                    } else {
                                        // ❌ Botón para eliminar los demás colores
                                        Button(action: {
                                            selectedColors.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                        }
                                        .offset(x: 3, y: -1)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    .padding(.top, 8)

                    // Botón "Continuar" solo si hay al menos un color
                    if selectedColors.count >= 1 {
                        NavigationLink(
                            destination: MosaicoResumenView(mosaico: mosaico, selectedColors: selectedColors),
                            isActive: $showResumen
                        ) {
                            Button(action: {
                                showResumen = true
                            }) {
                                Text("Continuar")
                                    .font(.subheadline.bold())
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.gray.opacity(0.9))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.top, 10)
                    }

                    // Espaciado final
                    Spacer(minLength: 40)
                }
            }

            // Bottom bar
            HStack {
                Spacer()
                Image(systemName: "cart")
                Spacer()
                NavigationLink(destination: FavoritosView()) {
                Image(systemName: "heart")
                };                Spacer()
                Image(systemName: "house")
                Spacer()
                Image(systemName: "bell")
                Spacer()
                Image(systemName: "person")
                Spacer()
            }
            .foregroundColor(.white)
            .font(.system(size: 25))
            .padding(25)
            .background(Color.black)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showColorSheet) {
            // Pasamos selectedColors como Binding
            ColorSelectionSheet(isPresented: $showColorSheet, selectedColors: $selectedColors)
        }
    }
}

// ARViewContainer
