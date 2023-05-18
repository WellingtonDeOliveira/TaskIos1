//
//  view.swift
//  TesteIos1
//
//  Created by userext on 16/05/23.
//

import Foundation
class View{
    
    func open(){
        print("""
                 ......Bem Vindo.......
                 ┊┊┊┊┊┊┊┊┊┊╱▏┊┊┊┊┊┊┊┊┊┊
                 ┊┊┊┊┊┊┊┊┊▕╱┊┊┊┊┊┊┊┊┊┊┊
                 ┊┊┊┊┊┊╱▔▔╲┊╱▔▔╲┊┊┊┊┊┊┊
                 ┊┊┊┊┊▕┈┈┈┈▔┈┈┈╱┊┊┊┊┊┊┊
                 ┊┊┊┊┊▕┈┈┈┈┈┈┈┈╲┊┊┊┊┊┊┊
                 ┊┊┊┊┊┊╲┈┈┈┈┈┈┈╱┊┊┊┊┊┊┊
                 ┊┊┊┊┊┊┊╲▂▂▂▂▂╱┊┊┊┊┊┊┊┊
                 Gerenciador de Tarefas
                \n
                Pressione enter para iniciar
                \n
                """)
        _ = readLine()
    }
    
    func editTopic() -> Void{
        print("\nEscolha um dos topicos abaixo:\n[a]. A fazer\n[b]. Fazendo\n[c]. Feito\n")
        print("*DIGITE A OPÇÅO DESEJADA :")
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
        guard let menu: String =  readLine() else{
            return menuInit()
        }
        return menu
    }
    
    func listar(tasks: [Task]){
        print(tasks.count == 0 ? "\n Nenhuma Tarefa cadastrada" : "\n------------------------------------------------------------------------------")
        for task in tasks {
            print("""
                    + Id: \(task.id) | Title: \(task.title) | Topic: \(task.topic) | Descrição: \(task.descript) +
                    ------------------------------------------------------------------------------
                    """)
        }
    }
    
    func search() {
      print("""
                
                Digite o id da tarefa que deseja selecionar:
                """)
    }
    
    func createName() -> Void{
        print("""
                Digite um nome para a sua Tarefa: 
                """)
    }
    
    func crateDescription() -> Void {
        print("""
                Digite uma Descrição para a sua nova Tarefa:
                """)
    }
    
    func remove(){
        print("""
                Tem certeza que deseja remover está tarefa?
                
                [s]. Sim
                [n]. Não
                """)
    }
    
    func edit(){
        print("""
              
              O que você deseja editar?
              
              [a]. Titulo
              [b]. Descrição
              
              [c]. Cancelar
              """)
    }
    
    func screenEdit(option: String, oldOption: String){
        print("""
              
              \(option) anterior: \(oldOption)
              Digite um novo valor para \(option)
              """)
    }
    
    func oldTopic(oldOption: String){
        print("""
              
              Topico anterior: \(oldOption)
              """)
    }
    
    func bye(){
        print("""
                Encerrando a aplicação . . .
                          ______
                         | Bye! |
                         |______|
                     /|/| |/
                    (ˆ-ˆ')/
                """)
    }
    
    func enterToContinue(){
      print("Pressione enter para continuar!")
      _ = readLine()
      print("\n\n\n")
    }
}
