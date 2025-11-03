//
//  KeyValuesEditView.swift
//  AppleContainerDesktop
//
//  Created by Itsuki on 2025/11/03.
//

import SwiftUI

struct KeyValuesEditView: View {
    @Binding var keyValues: [KeyValueModel]
    var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(alignment: .lastTextBaseline) {
                Text(title)
                Text("key=value")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Text("⭑ Anything with empty key will be removed when creating.")
                .lineLimit(1)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if keyValues.isEmpty {
                Button(action: {
                    self.keyValues.append(.init())
                }, label: {
                    Text("Add Key Value Pairs")
                        .padding(.horizontal, 2)
                })
                .buttonStyle(CustomButtonStyle(backgroundShape: .roundedRectangle(4), backgroundColor: .blue))
            }

            ForEach($keyValues, content: { $keyValue in
                
                AddableRow(content: {
                    TextField(text: $keyValue.key, label: {})
                    Text("=")
                    TextField(text: $keyValue.value, label: {})
                }, onAdd: {
                    self.keyValues.append(.init())
                }, onDelete: {
                    self.keyValues.removeAll(where: {$0.id == keyValue.id})
                })
                    

            })
        }

    }
}
