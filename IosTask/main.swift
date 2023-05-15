
//  main.swift
//  kanban
//
//  Created by userext on 09/05/23.
//

import Foundation
import AppKit

public struct Task: Codable{
    var uuid = UUID()
    var title: String
    var descript: String
    var topic: String
    
}

func menuInit() -> String {
    print("""
    GERENCIADOR DE ATIVIDADES🗓️
           _*MENU*_
    1- LISTAR ATIVIDADES
    2- ADICIONAR ATIVIDADES
    3- REMOVER ATIVIDADES
    4- EDITAR ATIVIDADES
    5- PESQUISAR ATIVIDADES
    6- MARCAR COMO CONCLUÍDA
    7- ENCERRAR A APLICAÇÃO

    _*DIGITE A OPÇÅO DESEJADA*_
    
    """)
    let menu: String =  readLine() ?? "0"
    return menu
}

func adquirirDados() ->  [Task] {
    do{
        return try decoder.decode([Task].self, from: jsonData as! Data)
    } catch{
        return []
    }
}

func adquirirData() -> Data? {
    return try? Data(contentsOf: fileURL)
}

let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("tasks")
let fileURLJson = fileURL.appendingPathComponent("tasks.json")
let jsonData = adquirirData()
let encoder = JSONEncoder()
let decoder = JSONDecoder()
var task = adquirirDados()

func escoTopic() -> String{
    print("\nEscolha um dos topicos abaixo:\n[a]. A fazer\n[b]. Fazendo\n[c]. Feito")
    let topicRamdon = readLine() ?? "d"
    switch topicRamdon {
    case "a":
        print("Topico escolhido: A fazer")
        return "A fazer"
    case "b":
        print("Topico escolhido: Fazendo")
        return "Fazendo"
    case "c":
        print("Topico escolhido: Feito")
        return "Feito"
    default:
        print("Digite um valor valido")
        return escoTopic()
    }
}

func menuopcoes ()->Void{
    
    switch menuInit() {
    case "1":
        print("Listar Atividade\n")
        listar()
        menuopcoes()
    case "2":
        print("Adiconar atividade \nDigite o valor do título:")
        let title = readLine() ?? ""
        var topic = escoTopic()
        print("\nDigite uma descrição:")
        let descript =  readLine() ?? ""
        salvar(title: title, topic: topic, descript: descript)
        menuopcoes()
    case "3":
        print("Remover Atividade")
        remover()
        menuopcoes()
    case "4":
        print("Editar Atividade")
        editar()
        menuopcoes()
    case "5":
        print("Mudar Topico da Atividade")
        for (index, tasks) in task.enumerated() {
            print("Índice: \(index) | Title: \(tasks.title) | Topic: \(tasks.topic)")
        }
        let valorEscolhidoS: String = readLine() ?? "0"
        
        let valorEscolhido = Int(valorEscolhidoS)
        print("\nTarefa selecionada: Title: \(task[valorEscolhido!].title) | Topic: \(task[valorEscolhido!].topic) | Descrição: \(task[valorEscolhido!].descript)\n")
        var newTopic = escoTopic()
        salvar(title: task[valorEscolhido!].title, topic: newTopic, descript: task[valorEscolhido!].descript)
        task.remove(at: valorEscolhido!)
        menuopcoes()
    case "6":
        print("Encerrando...")
        break
    default:
        print("Retornar o Menu")
        menuopcoes()
    }
}

func listar() -> Void {
    for tasks in task {
        print("Title: \(tasks.title) | Topic: \(tasks.topic) | Descrição: \(tasks.descript)")
    }
    print("\n")
}

func searchJSON(json: [String: Any], searchTerm: String, forKey key: String) -> [String] {
    var results: [String] = []

    // Verifica se a chave existe no JSON
    if let value = json[key] {
        if let stringValue = value as? String {
            // Verifica se o valor da chave é uma string e contém o termo de pesquisa
            if stringValue.localizedCaseInsensitiveContains(searchTerm) {
                results.append(key)
            }
        } else if let nestedJSON = value as? [String: Any] {
            // Se o valor da chave for outro JSON, chama recursivamente a função de pesquisa
            let nestedResults = searchJSON(json: nestedJSON, searchTerm: searchTerm, forKey: key)
            results += nestedResults.map { "\(key).\($0)" }
        }
    }

    return results
}

func salvar(title: String, topic: String, descript: String) -> Void{
    let aSalvar: Task = Task(title: title, descript: descript, topic: topic)
    task.append(aSalvar)
    
    do {
        encoder.outputFormatting = .prettyPrinted // Opcional: formatação para legibilidade
            let jsonData = try encoder.encode(task)
            FileManager.default.createFile(atPath: fileURL.path, contents: jsonData, attributes: nil)
            print("\n\nTitle: \(title) | Topic: \(topic) | Descrição: \(descript)\n")
    } catch {
        print("Erro ao codificar o objeto para JSON: \(error.localizedDescription)")
    }
}

func editar() -> Void {
    for (index, tasks) in task.enumerated() {
        print("Índice: \(index) | Title: \(tasks.title) | Topic: \(tasks.topic)")
    }
    let valorEscolhidoS: String = readLine() ?? "0"
    
    let valorEscolhido = Int(valorEscolhidoS)
    print("Título: \(task[valorEscolhido!].title) | Topico: \(task[valorEscolhido!].topic) | Descrição: \(task[valorEscolhido!].descript)\n\n")
    print("Qual campo abaixo você deseja alterar?\n\n[a]. Título\n[b]. Topico\n[c]. Descrição")
    
    let valorCampo: String = readLine() ?? "d"
    switch valorCampo {
        case "a":
            print("Campo escolhido Titulo, por favor, digite um novo valor")
            let newValueTitle: String = readLine() ?? ""
            salvar(title: newValueTitle, topic: task[valorEscolhido!].topic, descript: task[valorEscolhido!].descript)
            task.remove(at: valorEscolhido!)
        case "b":
            print("Campo escolhido Topico\n")
            var newValueTopic: String = escoTopic()
            salvar(title: task[valorEscolhido!].title, topic: newValueTopic, descript: task[valorEscolhido!].descript)
            task.remove(at: valorEscolhido!)
        case "c":
            print("Campo escolhido Descrição, por favor, digite um novo valor")
            let newValueDescript: String = readLine() ?? ""
            salvar(title: task[valorEscolhido!].title, topic: task[valorEscolhido!].topic, descript: newValueDescript)
            task.remove(at: valorEscolhido!)
        default:
            print("Digite um valor valido")
    }
    do {
        encoder.outputFormatting = .prettyPrinted // Opcional: formatação para legibilidade
            let jsonData = try encoder.encode(task)
            FileManager.default.createFile(atPath: fileURL.path, contents: jsonData, attributes: nil)
    } catch {
        print("Erro ao codificar o objeto para JSON: \(error.localizedDescription)")
    }
}

func remover() -> Void {
    for (index, tasks) in task.enumerated() {
        print("Índice: \(index) | Title: \(tasks.title) | Topic: \(tasks.topic)")
    }
    let valorEscolhidoS: String = readLine() ?? "0"
    
    let valorEscolhido = Int(valorEscolhidoS)
    
    task.remove(at: valorEscolhido!)
    
    do {
        encoder.outputFormatting = .prettyPrinted // Opcional: formatação para legibilidade
            let jsonData = try encoder.encode(task)
            FileManager.default.createFile(atPath: fileURL.path, contents: jsonData, attributes: nil)
            print("Usuario removido com sucesso")
    } catch {
        print("Erro ao codificar o objeto para JSON: \(error.localizedDescription)")
    }
}

menuopcoes()

//    case "5":
//        print("Pesquisar Atividade")
//        do {
//            guard let newjson = jsonData,
//                  let json = try JSONSerialization.jsonObject(with: newjson, options: []) as? [String: Any]
//            else {
//                return
//            }
//
//
//         // Realiza a pesquisa no JSON na chave "cores"
//         let searchTerm = "rapadura"
//         let searchKey = "title"
//         let searchResults = searchJSON(json: json, searchTerm: searchTerm, forKey: searchKey)
//
//         // Exibe os resultados
//         if searchResults.isEmpty {
//             print("Nenhum resultado encontrado para '\(searchTerm)' na chave '\(searchKey)'.")
//         } else {
//             print("Resultados para '\(searchTerm)' na chave '\(searchKey)':")
//             for result in searchResults {
//                 print(result)
//             }
//         }
//        } catch {
//            print("Erro ao processar o JSON: \(error)")
//        }
//        menuopcoes()
