# Sistema de Frete

## Tabela de Conteúdos
  * [Status do projeto](#status-do-projeto)
  * [Descrição do projeto](#descrição-do-projeto)
  * [Funcionalidades](#funcionalidades)
  * [Como rodar a aplicação](#como-rodar-a-aplicação)
  * [Como rodar os testes](#como-rodar-os-testes)
  * [Informações adicionais](#informações-adicionais)

## Status do projeto
<p align = "justify"> Em desenvolvimento :warning: </p>

## Descrição do projeto

<p align = "justify"> Aplicação para Sistema de Frete desenvolvida como parte da 1a etapa da turma 9 do Treinadev. </p>

## Funcionalidade

- [X] Somente usuários com domínio @sistemadefrete.com.br podem fazer login.

## Como rodar a aplicação

<p align = "justify"> No terminal, clone o projeto: </p>

```
$ git clone git@github.com:RaphaellyV/delivery-app-t9.git
```

<p align = "justify"> Entre na pasta do projeto: </p>

```
$ cd delivery-app-t9
```

<p align = "justify"> Instale as dependencias: </p>

```
$ bin/setup
```

<p align = "justify"> Popule a aplicação: </p>

```
$ rails db:seed
```

<p align = "justify"> Visualize no navegador: </p>

```
$ rails s
```

* Acesse http://localhost:3000/

## Como rodar os testes

```
$ rspec
```

## Informações adicionais

* Projeto sendo desenvolvido em: https://github.com/users/RaphaellyV/projects/2.

* Gems instaladas: capybara, rspec, devise 

* Usuário regular cadastrado: maria@sistemadefrete.com.br (senha: password)