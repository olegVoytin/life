//
//  DoublyLinkedList.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

// Класс для узла двусвязного списка
final class DoublyLinkedListNode<T> {
    var value: T
    var next: DoublyLinkedListNode?
    weak var previous: DoublyLinkedListNode?

    init(value: T) {
        self.value = value
    }
}

// Класс для двусвязного списка
class DoublyLinkedList<T> {
    private var head: DoublyLinkedListNode<T>?
    private var tail: DoublyLinkedListNode<T>?

    // Проверка на пустоту списка
    var isEmpty: Bool {
        return head == nil
    }

    // Возвращает первый элемент списка
    var first: DoublyLinkedListNode<T>? {
        return head
    }

    // Возвращает последний элемент списка
    var last: DoublyLinkedListNode<T>? {
        return tail
    }

    // Добавление нового элемента в конец списка
    func append(value: T) {
        let newNode = DoublyLinkedListNode(value: value)
        if let tailNode = tail {
            newNode.previous = tailNode
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
    }

    // Добавление нового элемента в начало списка
    func prepend(value: T) {
        let newNode = DoublyLinkedListNode(value: value)
        if let headNode = head {
            newNode.next = headNode
            headNode.previous = newNode
        } else {
            tail = newNode
        }
        head = newNode
    }

    // Удаление всех элементов из списка
    func removeAll() {
        head = nil
        tail = nil
    }

    // Удаление узла
    func remove(node: DoublyLinkedListNode<T>) -> T {
        let prev = node.previous
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }

        if let next = next {
            next.previous = prev
        } else {
            tail = prev
        }

        node.previous = nil
        node.next = nil

        return node.value
    }

    // Функция поиска элемента по значению
    func search(value: T) -> DoublyLinkedListNode<T>? where T: Equatable {
        var currentNode = head
        while currentNode != nil {
            if currentNode?.value == value {
                return currentNode
            }
            currentNode = currentNode?.next
        }
        return nil
    }
}
