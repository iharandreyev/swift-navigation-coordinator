//
//  WeakRef.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

enum SceneSessionInfoKey: String {
  case uiApplication
}

struct WeakRef<Object: AnyObject> {
  private(set) weak var object: Object?
  
  init(object: Object) {
    self.object = object
  }
}
