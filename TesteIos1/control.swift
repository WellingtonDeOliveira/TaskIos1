//
//  control.swift
//  TesteIos1
//
//  Created by userext on 16/05/23.
//

import Foundation

class Control {
    let view: View = View()
    
    let jsonControler = JsonControler()
    lazy var taskList: TaskList = {
        guard let task = jsonControler.getJson() else {
            return TaskList(task: [])
        }
        return task
    }()
    
    func menuOpcoes () -> Void{
        switch View().menuInit() {
        case "1":
            view.listar(tasks: taskList.task)
            view.enterToContinue()
            menuOpcoes()
        case "2":
            guard let task = createNewTask() else {
                print("Arquivo Json Corrompido")
                return menuOpcoes()
            }
            jsonControler.postJson(taskList)
            view.listar(tasks: [task])
            view.enterToContinue()
            menuOpcoes()
        case "3":
            view.listar(tasks: taskList.task)
            view.search()
            let index = IndexTask()
            remove(task: index)
            view.enterToContinue()
            menuOpcoes()
        case "4":
            view.listar(tasks: taskList.task)
            view.search()
            let index = IndexTask()
            editTask(index)
            view.enterToContinue()
            menuOpcoes()
        case "5":
            view.listar(tasks: taskList.task)
            view.search()
            let index = IndexTask()
            editTopic(index)
            view.enterToContinue()
            menuOpcoes()
        case "6":
            jsonControler.postJson(taskList)
            view.bye()
            break
        default:
            print("Opção Inválida")
            view.enterToContinue()
            menuOpcoes()
        }
    }
    
    func topic() -> String{
        guard let topicRamdon = readLine() else {
            return topic()
        }
        switch topicRamdon {
        case "a", "A":
            print("\nTopico escolhido: A fazer\n")
            return "A fazer"
        case "b", "B":
            print("\nTopico escolhido: Fazendo\n")
            return "Fazendo"
        case "c", "C":
            print("\nTopico escolhido: Feito\n")
            return "Feito"
        default:
            print("\nDigite um valor valido\n")
            return topic()
        }
    }
    
    func editTopic(_ index: Int) -> Void {
        view.oldTopic(oldOption: taskList.task[index].topic)
        view.editTopic()
        let newTopic = topic()
        taskList.task[index].topic = newTopic
        print("Mudança de topico concluida com suecsso!")
    }
    
    func createNewTask() -> Task? {
        view.createName()
        guard let newTitle: String = readLine() else {
            print("Digite um nome válido")
            return createNewTask()
        }
        view.crateDescription()
        guard let newDescription: String = readLine() else {
            print("Digite uma descrição válida")
            return createNewTask()
        }
        
        view.editTopic()
        let newTopic = topic()
        
        let newTask = Task(id: taskList.task.count + 1 ,title: newTitle, descript: newDescription, topic: newTopic)
        taskList.task.append(newTask)
        return newTask
    }
    
    func IndexTask() -> Int{
        while(true){
            guard let numberStr = readLine() else {
                continue
            }
            guard let number: Int = Int(numberStr) else{
                menuOpcoes()
                continue
            }
            guard let index: Int = taskList.task.firstIndex(where: { $0.id == number}) else{
                print("\n! Id invalido!")
                continue
            }
            return index
        }
    }
    
    func remove(task index:Int) {
        view.remove()
        guard let confirm: String = readLine() else {
            return remove(task: index )
        }
        if(confirm == "s" || confirm == "S"){
            taskList.task.remove(at: index)
            print("Tarefa removida com sucesso\n")
            view.enterToContinue()
            menuOpcoes()
        } else if(confirm == "n" || confirm == "N"){
            print("Operacao cancelada\n")
        } else {
            print("Opção Inválida\n")
            remove(task: index)
        }
    }
    
    func editTask(_ index: Int) {
        view.edit()
        
        guard let option: String = readLine() else {
            return editTask(index)
        }
        switch option {
        case "a", "A":
            view.screenEdit(option: "titulo", oldOption: taskList.task[index].title)
            guard let newTitle: String = readLine() else {
                return editTask(index)
            }
            taskList.task[index].title = newTitle
        case "b", "B":
            view.screenEdit(option: "descrição", oldOption: taskList.task[index].descript)
            guard let newDescription: String = readLine() else {
                return editTask(index)
            }
            taskList.task[index].descript = newDescription
        case "c", "C":
            print("""
                    Edicão cancelada com sucesso!\n
                    """)
            view.enterToContinue()
            menuOpcoes()
        default:
            print("Opção inválida")
            return editTask(index)
        }
        print("\n Tarefa editada com sucesso!\n")
    }
}
