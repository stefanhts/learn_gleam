import gleam/io
import gleam/int
import gleam/string
import gleam/erlang

pub fn main() {
  fact()
  fib()
}

fn fib() {
  let assert Ok(s) = erlang.get_line("fib > ")
  let trimmed = string.trim(s)
  let assert Ok(i) = int.base_parse(trimmed, 10)
  io.println("Tail recursive version:")
  io.debug(fib_tail(i, 0, 1))
  io.println("Non tail recursive version:")
  io.debug(fib_normal(i))
}

fn fact() {
  let assert Ok(s) = erlang.get_line("factorial > ")
  let trimmed = string.trim(s)
  let assert Ok(i) = int.base_parse(trimmed, 10)
  io.println("Tail recursive version:")
  io.debug(fact_tail(i, 1))
  io.println("Non tail recursive version:")
  io.debug(fact_non(i))
}

fn fact_tail(n: Int, acc: Int) -> Int {
  case n {
    0 -> acc
    n -> fact_tail(n - 1, n * acc)
  }
}

fn fact_non(n: Int) -> Int {
  case n {
    0 -> 1
    n -> n * fact_non(n - 1)
  }
}

fn fib_tail(n: Int, a: Int, b: Int) -> Int {
  case n {
    0 -> a
    1 -> b
    n -> fib_tail(n - 1, b, a + b)
  }
}

fn fib_normal(n: Int) -> Int {
  case n {
    0 -> 0
    1 -> 1
    n -> fib_normal(n - 1) + fib_normal(n - 2)
  }
}
