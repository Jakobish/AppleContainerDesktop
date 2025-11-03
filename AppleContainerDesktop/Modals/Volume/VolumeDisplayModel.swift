//
//  VolumeDisplayModel.swift
//  AppleContainerDesktop
//
//  Created by Itsuki on 2025/11/03.
//

import Foundation

import ContainerClient

@dynamicMemberLookup
struct VolumeDisplayModel: Identifiable {
    var volume: Volume
    
    
    var created: String {
        return Formatter.dateFormatter.string(from: volume.createdAt)
    }
    
    var size: String? {
        guard let volumeSize = volume.sizeInBytes else {
            return nil
        }
        let formattedSize = Formatter.byteCountFormatter.string(fromByteCount: Int64(volumeSize))
        return formattedSize
    }
    
    var id: String {
        return volume.id
    }
    
    var inUseContainers: [ClientContainer]
    var inUse: Bool {
        return !inUseContainers.isEmpty
    }
    
    var volumeType: VolumeType {
        self.volume.isAnonymous ? .anonymous : .named
    }
    
    var labels: [String : String] {
        self.volume.labels.filter({$0.key != Volume.anonymousLabel})
    }
    
    var options: [String : String] {
        self.volume.options.filter({$0.key != Volume.sizeOptionKey})
    }

    init(_ volume: Volume, containers: [ClientContainer]) {
        self.volume = volume
        self.inUseContainers = containers.filter({ container in
            container.volumeNames.contains(volume.name)
        })
    }

}

extension VolumeDisplayModel {
    subscript<T>(dynamicMember keyPath: KeyPath<Volume, T>) -> T {
        return volume[keyPath: keyPath]
    }
}
