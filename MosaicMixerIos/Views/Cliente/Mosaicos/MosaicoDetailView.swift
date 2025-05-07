import SwiftUI

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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Contenido principal de la vista
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
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

                        // Picker de modos
                        HStack(spacing: 0) {
                            ForEach(0..<modes.count, id: \.self) { index in
                                Text(modes[index])
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(selectedMode == index ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedMode == index ? .white : .black)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        if selectedMode != index {
                                            selectedColors = []
                                            selectedMode = index
                                            if selectedMode == 1 {
                                                currentManualColor = selectedColors.first
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)

                        // ARView y selección de colores
                        if selectedMode == 0 {
                            StaticARViewContainer(selectedColors: selectedColors, modelName: mosaico.imagen, isStatic: true)
                                .id(selectedColors.count)
                                .frame(height: geometry.size.height * 0.6)
                                .background(Color.white)
                        } else {
                            ManualARViewContainer(currentColor: $currentManualColor, modelName: mosaico.imagen)
                                .id(selectedColors.count)
                                .frame(height: geometry.size.height * 0.6)
                                .background(Color.white)
                        }

                        // Botón para añadir color con un diseño más moderno
                        Button(action: {
                            if selectedColors.count < 3 {
                                showColorSheet = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    if selectedMode == 1 {
                                        currentManualColor = selectedColors.last
                                    }
                                }
                            } else {
                                print("Ya has seleccionado 3 colores.")
                            }
                        }) {
                            Label("Añadir color", systemImage: "plus")
                                .font(.headline)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }

                        // Scroll horizontal para mostrar los colores seleccionados
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Array(selectedColors.enumerated()), id: \.element.id) { index, color in
                                    ZStack(alignment: .topTrailing) {
                                        VStack(spacing: 4) {
                                            Image(color.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 80)
                                                .cornerRadius(12)
                                                .shadow(radius: 6)

                                            Text(color.name)
                                                .font(.caption)
                                                .foregroundColor(.black)

                                            Text(color.price)
                                                .font(.caption2)
                                                .fontWeight(.medium)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.bottom, 8)

                                        // Botón para editar color
                                        Button(action: {
                                            selectedColors.remove(at: 0)
                                            showColorSheet = true
                                        }) {
                                            Image(systemName: "pencil.circle.fill")
                                                .foregroundColor(.blue)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .shadow(radius: 3)
                                        }
                                        .offset(x: 3, y: -3)

                                        // Botón para eliminar color
                                        Button(action: {
                                            selectedColors.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .shadow(radius: 3)
                                        }
                                        .offset(x: 3, y: -3)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Continuar con los colores seleccionados
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
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 24)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                        .shadow(radius: 5)
                                }
                            }
                            .padding(.top, 10)
                        }

                        Spacer(minLength: 40)
                    }
                }
                .padding(.bottom, 0) // No hay espacio adicional en el fondo
            }
            .edgesIgnoringSafeArea(.bottom) // Esto asegura que el TabView no esté cubierto
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showColorSheet) {
            ColorSelectionSheet(isPresented: $showColorSheet, selectedColors: $selectedColors)
        }
    }
}
