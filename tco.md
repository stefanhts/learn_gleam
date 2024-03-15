
# Tail Call Optimization
A Stefan Heller venture into programming language features

---

## What is Tail Call Optimization?

> TCO is a optimization technique present in some compilers and interpreters
which allow programs to reuse function call stacks and perform high numbers of
iterations which would normally result in a stack overflow.

## What languages support Tail Call Optimization?

> Pretty much all functional languages, Zig, Swift, Kotlin, Lua, and some others

---

## How does a recursion function call work by default?

```go
func factorial(n int) int {
    if n == 0 {
        return 1
    }
    return n * factorial(n-1)
}
```
```asm
section .text
global factorial

factorial:
    ; Prologue
    push ebp            ; Save the current base pointer
    mov ebp, esp        ; Set up a new base pointer
    
    ; Function body
    mov eax, [ebp+8]    ; Load n into eax
    cmp eax, 0          ; Compare n with 0
    je .base_case       ; If n == 0, jump to base case
    
    ; Recursive case
    dec eax             ; Decrement n
    push eax            ; Push (n - 1) onto the stack
    call factorial      ; Recursive call to factorial(n - 1)
    pop eax             ; Restore n from the stack
    imul eax, [ebp+8]   ; Multiply result of recursive call by n
    jmp .end            ; Jump to end
    
.base_case:
    mov eax, 1          ; Return 1 if n == 0
    
.end:
    ; Epilogue
    pop ebp             ; Restore the previous base pointer
    ret                 ; Return from the function
```

---
## Let's walk through how recursive function calls work
1. First we push the current base pointer to the stack
2. Then we set our current return line
3. We push our arguments onto the stack
4. We push our local veriables
5. We do our function body until we reach our next function call
6. We then call the function again:
    a. push pointer
    b. push arguments
    c. push locals
    d. do body
    ...

> Each time we do the function calls we have to put a bunch of information on
to the stack. If we continue to nest the stack size can rise very quickly. In the 
case of the fibonacci sequence, the stack grows at a rate of ~2^n, so imagine what happens
when n is 100 or 1000... the stack will overflow.

---

# Enter Tail Call Recursion!!
## If the compiler (or interpreter) can figure out that the recursive calls can be optimized, it can replace these stack pushes

> Instead of pushing each argument to the stack as well as the return address, we can treat the function as a loop.
This is how functional languages manage to be fast despite not having loop support in their syntax. 

---
# Let's do some tail recursion
## Let's start by writing some code in a language that supports tail recursion
```gleam
fn factorial(n: Int) -> Int {
    case n {
        0 -> 1
        n -> n * factorial(n-1)
    }
}
```
## We need the final statement to only be a function call
```gleam
fn factorial(n: Int, acc: Int) -> Int {
    case n {
        0 -> 1
        n -> factorial(n-1, n * acc)
    }
}
```
---

# Demonstration time


