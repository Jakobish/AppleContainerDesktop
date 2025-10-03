//
//  AddRemoteImageView.swift
//  AppleContainerDesktop
//
//  Created by Itsuki on 2025/09/19.
//

import SwiftUI
internal import ContainerizationOCI
import ContainerClient

struct AddRemoteImageView: View {
    @Environment(ApplicationManager.self) private var applicationManager
    @Environment(\.dismiss) private var dismiss
    
    var onPullImageFinish: () -> Void
    
    @SwiftUI.State private var text: String = ""
    @SwiftUI.State private var errorMessage: String?
    
    @SwiftUI.State private var showProgressView: Bool = false
    
    @SwiftUI.State private var showAdditionalSettings: Bool = true
    
    @SwiftUI.State private var platformString: String = Platform.current.description
    @SwiftUI.State private var requestScheme: RequestScheme = .auto


    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading) {
                Text("Pull Remote Image")
                    .font(.headline)
                
                Text("Please Enter the image reference. For example: \n1. `alpine:latest` \n2. `docker.io/exampleuser/demo:latest` ")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)

            }
                        
            VStack(alignment: .leading) {
                TextField("", text: $text)
                
                if let errorMessages = self.errorMessage {
                    Text(errorMessages)
                        .font(.subheadline)
                        .foregroundStyle(.red)

                }

            }
            
            Divider()
            
            
            // TODO: add more configurations
            Button(action: {
                showAdditionalSettings.toggle()
            }, label: {
                HStack {
                    Text("Additional Settings")
                    Spacer()
                    Image(systemName: showAdditionalSettings ? "chevron.up" : "chevron.down")
                        .padding(.trailing, 4)
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            })
            .buttonStyle(.plain)
            
            if showAdditionalSettings {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Platform")
                    Text("⭑ The value takes the form of os/arch or os/arch/variant, ex: `linux/amd64` or `linux/arm/v7`.")
                        .lineLimit(1)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    TextField(text: $platformString, prompt: Text("Ex: linux/amd64"), label: {})
                }
                
                HStack(alignment: .lastTextBaseline) {
                    Text("Request Scheme")
                    Picker(selection: $requestScheme, content: {
                        let schemes: [RequestScheme] = [.auto, .http, .https]
                        ForEach(schemes, id: \.self) { scheme in
                            Text(scheme.rawValue)
                                .tag(scheme)
                        }
                    }, label: {})
                    .labelsHidden()
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

            }
            
            
            Divider()

                            
            HStack(spacing: 16) {
                Button(action: {
                    self.dismiss()
                }, label: {
                    Text("Cancel")
                        .padding(.horizontal, 2)
                })
                .buttonStyle(CustomButtonStyle(backgroundShape: .roundedRectangle(4), backgroundColor: .secondary))
                
                Button(action: {
                    let trimmedReference = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedReference.isEmpty else {
                        self.errorMessage = "Image reference cannot be empty."
                        return
                    }
                    
                    Task {
                        self.showProgressView = true
                        
                        do {
                            let platform = try Platform(from: self.platformString)
                            
                            try await ImageService.pullImage(
                                reference: trimmedReference,
                                platform: platform,
                                scheme: self.requestScheme,
                                messageStreamContinuation:
                                    self.applicationManager.messageStreamContinuation
                            )

                            self.onPullImageFinish()
                            self.dismiss()

                        } catch (let error) {
                            self.errorMessage = "\(error)"
                        }
                        
                        self.showProgressView = false
                        
                    }
                }, label: {
                    Text("Pull")
                        .padding(.horizontal, 2)
                })
                .buttonStyle(CustomButtonStyle(backgroundShape: .roundedRectangle(4), backgroundColor: .blue))
            }
            
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .padding(.all, 24)
        .frame(width: 480)
        .fixedSize(horizontal: false, vertical: true)
        .sheet(isPresented: $showProgressView, content: {
            CustomProgressView()
                .environment(self.applicationManager)
        })
        .onDisappear {
            self.showProgressView = false
        }
        .interactiveDismissDisabled()
      
    }

}
