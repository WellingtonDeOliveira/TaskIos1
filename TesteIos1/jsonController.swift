//
//  jsonControler.swift
//  TesteIos1
//
//  Created by userext on 16/05/23.
//

import Foundation

class JsonControler {
    let fileManager = FileManager.default

    func getJson() -> TaskList? {
        let nomeJson = "tasks.json"
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let jsonURL = documentsURL.appendingPathComponent(nomeJson)

        if fileManager.fileExists(atPath: jsonURL.path){
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                let decoder = JSONDecoder()
                let atividade = try decoder.decode(TaskList.self, from: jsonData)
                return atividade
            } catch {
                return nil
           }
        } else {
            do {
                try "".write(to: jsonURL, atomically: true, encoding: .utf8)
                return TaskList(task:[])
            } catch {
                return nil
            }
        }
    }

    
    func postJson(_ task : TaskList) {
        let nomeJson = "tasks.json"
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let jsonURL = documentsURL.appendingPathComponent(nomeJson)
        do {
            let data = try JSONEncoder().encode(task)
            try data.write(to: jsonURL)
        } catch {
            return
        }
    }
}
