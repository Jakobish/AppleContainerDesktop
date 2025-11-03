//
//  KeyValuesDisplayView.swift
//  AppleContainerDesktop
//
//  Created by Itsuki on 2025/11/03.
//

import SwiftUI

struct KeyValuesDisplayView: View {
    var keyValues: [KeyValueModel]
    var emptyText: String
    
    var leftColumnWidth: CGFloat = 240
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            
            if keyValues.isEmpty {
                emptyText(emptyText)
            }
            
            ForEach(keyValues) { keyValue in
                HStack {
                    leftColumn(keyValue.key)
                    rightColumn(keyValue.value)
                }
                .padding(.horizontal, 16)
                
                Divider()
            }
        })

    }
    
    private func emptyText(_ text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 16)
    }
    
    private func leftColumn(_ text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.leading)
            .frame(width: self.leftColumnWidth, alignment: .leading)
            .foregroundStyle(.secondary)
    }
    
    private func rightColumn(_ text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

}
