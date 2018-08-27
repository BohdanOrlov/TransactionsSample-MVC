//
//  Protocols.swift
//  Xapo
//
//  Created by Thomas Angistalis on 26/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import Foundation

protocol ServicesFactory {
    func makeLootService() -> NetworkManager<LootAPI>
}
