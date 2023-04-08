# rk_solucoes

UI responsável por fazer a conversāo utilizando o package proprietário em Rust chamado rk_parser
https://github.com/MateusHBR/rk_parser

# metricas

- Input de 369 mil linhas.

### Utilizando Rust:
flutter: RUST STARTED
flutter: RUST STOP - 2019ms

### Utilizando Dart:
flutter: DART STARTED
flutter: DART STOP - 33832ms


## Setup do projeto
Flutter e Rust pré instalados na máquina, instalando todas dependências necessárias pelo package responsável pelo FFI entre Dart e Rust
https://github.com/fzyzcjy/flutter_rust_bridge/tree/master/frb_example/with_flutter

Por fim, executar:

```
$ make setup
```