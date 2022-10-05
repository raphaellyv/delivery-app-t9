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

## Funcionalidades

- [X] Somente usuários com domínio @sistemadefrete.com.br podem fazer login.
- [X] Usuários administradores podem cadastrar uma ordem de serviço com status pendente.
- [X] Usuários regulares e administradores podem ver lista de ordens de serviço.
- [X] Usuários regulares e administradores podem ver detalhes de uma ordem de serviço.
- [X] Visitantes podem buscar por uma ordem de serviço pelo código de rastreio.

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

* Usuário regular cadastrado: maria@sistemadefrete.com.br (senha: password)

* Usuário administrador cadastrado: pessoa@sistemadefrete.com.br (senha: password)

* Projeto sendo desenvolvido em: https://github.com/users/RaphaellyV/projects/2.

* Gems instaladas: bootstrap, capybara, devise, rspec