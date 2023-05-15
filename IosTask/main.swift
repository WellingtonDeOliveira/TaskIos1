
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
    ==========================
    +         _*MENU*_        +
    ---------------------------
    | 1- LISTAR ATIVIDADES     |
    ---------------------------
    | 2- ADICIONAR ATIVIDADES  |
    ---------------------------
    | 3- REMOVER ATIVIDADES    |
    ---------------------------
    | 4- EDITAR ATIVIDADES     |
    ---------------------------
    | 5- MUDAR TOPICO DA ATIV. |
    ---------------------------
    | 6- ENCERRAR A APLICAÇÃO  |
    ---------------------------

    *DIGITE A OPÇÅO DESEJADA :
    
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
    print("\nEscolha um dos topicos abaixo:\n[a]. A fazer\n[b]. Fazendo\n[c]. Feito\n")
    print("*DIGITE A OPÇÅO DESEJADA :")
    let topicRamdon = readLine() ?? "d"
    switch topicRamdon {
    case "a":
        print("\nTopico escolhido: A fazer\n")
        return "A fazer"
    case "b":
        print("\nTopico escolhido: Fazendo\n")
        return "Fazendo"
    case "c":
        print("\nTopico escolhido: Feito\n")
        return "Feito"
    default:
        print("\nDigite um valor valido\n")
        return escoTopic()
    }
}

func menuopcoes ()->Void{
    
    switch menuInit() {
    case "1":
        print("Listar Atividade\n")
        listar()
        print("Pressione Enter para continuar")
        _ = readLine()
        menuopcoes()
    case "2":
        print("\nAdiconar atividade \n\nDigite o valor do título:")
        let title = readLine() ?? ""
        var topic = escoTopic()
        print("\nDigite uma descrição:")
        let descript =  readLine() ?? ""
        salvar(title: title, topic: topic, descript: descript)
        print("Pressione Enter para continuar")
        _ = readLine()
        menuopcoes()
    case "3":
        print("Remover Atividade")
        remover()
        print("Pressione Enter para continuar")
        _ = readLine()
        menuopcoes()
    case "4":
        print("Editar Atividade")
        editar()
        print("Pressione Enter para continuar")
        _ = readLine()
        menuopcoes()
    case "5":
        print("Mudar Topico da Atividade")
        print("------------------------------------------------------------------------------")
        for (index, tasks) in task.enumerated() {
            
            print("+ Índice: \(index) | Title: \(tasks.title) | Topic: \(tasks.topic) +")
            print("------------------------------------------------------------------------------")
        }
        let valorEscolhidoS: String = readLine() ?? "0"
        
        let valorEscolhido = Int(valorEscolhidoS)
        print("\nTarefa selecionada: Title: \(task[valorEscolhido!].title) | Topic: \(task[valorEscolhido!].topic) | Descrição: \(task[valorEscolhido!].descript)\n")
        var newTopic = escoTopic()
        salvar(title: task[valorEscolhido!].title, topic: newTopic, descript: task[valorEscolhido!].descript)
        task.remove(at: valorEscolhido!)
        print("Pressione Enter para continuar")
        _ = readLine()
        menuopcoes()
    case "6":
        print("Encerrando...")
        break
    default:
        print("Opção Invalida")
        print("Pressione Enter para continuar")
        _ = readLine()
        menuopcoes()
    }
}

func listar() -> Void {
    print("------------------------------------------------------------------------------")
    for tasks in task {
        print("""
                + Title: \(tasks.title) | Topic: \(tasks.topic) | Descrição: \(tasks.descript) +
                ------------------------------------------------------------------------------
                """)
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
        print("------------------------------------------------------------------------------")
            print("+ Title: \(title) | Topic: \(topic) | Descrição: \(descript) +")
        print("------------------------------------------------------------------------------")
    } catch {
        print("Erro ao codificar o objeto para JSON: \(error.localizedDescription)")
    }
}

func editar() -> Void {
    for (index, tasks) in task.enumerated() {
        print("------------------------------------------------------------------------------")
        print("+ Índice: \(index) | Title: \(tasks.title) | Topic: \(tasks.topic) +")
        print("------------------------------------------------------------------------------")
    }
    let valorEscolhidoS: String = readLine() ?? "0"
    
    let valorEscolhido = Int(valorEscolhidoS)
    print("Título: \(task[valorEscolhido!].title) | Topico: \(task[valorEscolhido!].topic) | Descrição: \(task[valorEscolhido!].descript)\n\n")
    print("Qual campo abaixo você deseja alterar?\n\n[a]. Título\n[b]. Topico\n[c]. Descrição\n")
    print("*DIGITE A OPÇÅO DESEJADA :")
    
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
    print("------------------------------------------------------------------------------")
    for (index, tasks) in task.enumerated() {
        print("+ Índice: \(index) | Title: \(tasks.title) | Topic: \(tasks.topic) +")
        print("------------------------------------------------------------------------------")
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
