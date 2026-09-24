package com.example

data class User(val name: String, var age: Int)

fun greet(user: User, prefix: String = "Hi"): String {
    return "$prefix, ${user.name}! age=${user.age}"
}
