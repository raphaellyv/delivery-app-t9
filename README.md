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

<p align = "justify"> Aplicação para Sistema de Frete desenvolvida em Ruby on Rails como parte da 1a etapa da turma 9 do Treinadev. </p>

## Funcionalidades

- [X] Somente usuários com domínio @sistemadefrete.com.br podem fazer login.
- [X] Usuários com domínio @sistemadefrete.com.br podem fazer cadastro e terão acesso como usuário regular.

- [X] Usuários administradores podem cadastrar uma ordem de serviço com status pendente.
- [X] Usuários regulares e administradores podem ver lista de ordens de serviço.
- [X] Usuários regulares e administradores podem ver detalhes de uma ordem de serviço.
- [X] Visitantes podem buscar por uma ordem de serviço pelo código de rastreio.

- [X] Usuários regulares podem ver lista contendo somente modalidades de transporte ativas.
- [X] Usuários administradores podem ver lista de contendo todas as modalidades de transporte e seus status.
- [X] Usuários administradores e regulares podem ver detalhes de uma modalidade de transporte.
- [X] Usuários administradores podem criar modalidades de transporte com o status "Ativa".
- [X] Usuários administradores podem alterar o status de uma modalidade de transporte para "Ativa" ou "Inativa".
- [X] Usuários administradores podem editar uma modalidade de transporte.

- [X] Usuários administradores e regulares podem ver lista de veículos cadastrados. Cada veículo pertence a uma modalidade de transporte e pode ter status "Disponível", "Em Manutenção" ou "Em Entrega".

- [X] Usuários administradores e regulares podem ver lista de prazos de entrega cadastrados. Cada prazo pertence a uma modalidade de transporte.

- [X] Úsuários administradores e regulares podem ver o orçamento na tela de detalhes de ordens de serviço pendentes.

- [X] Úsuários administradores e regulares podem selecionar transportadoras para ordens de serviço pendentes, sendo atribuídos a ela o status "Em Transporte", um veículo, preço total e data prevista de entrega.

- [X] Úsuários administradores e regulares podem finalizar uma ordem de serviço, tornando o veículo utilizado disponível para outra entrega. Caso a entrega seja realizada com atraso, o usuário deverá informar o motivo do atraso.

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