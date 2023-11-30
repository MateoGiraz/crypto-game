[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/B8-f4DG0)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=12461672&assignment_repo_type=AssignmentRepo)
# Gaming platform

## Setup

1. Clonar el repositorio `git clone <route to repo>`
2. Instalar dependencias `npm install`
3. Compile la solución `npx hardhat compile`
4. Ejecute todos los test  `npx hardhat test`

## **IMPORTANTE** Suba sus cambios al repositorio
## **IMPORTANTE** Sin esta acción el trabajo se tomará como no entregado

1. Publicar cambios a su repositorio

`git add .`  
`git commit -m "<<your comments here>>"`  
`git push origin main`

## Descripción de proyecto:

El proyecto consta de una Dapp con las interfaces proporcionadas implementadas en solidity y un frontend en react (Version 17.02).
El proyecto consta de un ecosistema de contratos inteligentes destinados a gestionar un sistema de personajes y armas no fungibles (NFTs).

- Contrato OwnersContract:

Funciona como un registro centralizado de propietarios y sus contratos asociados.
Otorga autoridad a los propietarios para realizar ciertas operaciones en los contratos del ecosistema.

- Contrato Rubie:

Gestiona la economia interna del sistema (Rubíes).
Permite la transferencia de Rubíes entre usuarios para intercambiar para por armas o personajes (NFTs).

- Contrato Experience: 

Gestiona la experiencia  de los jugadores, se necesita para comprar algunos personajes y puede comprarse para sumar estadísticas.

- Contrato Character:

Este contrato representa la lógica central de los personajes no fungibles. Permite la creación, transferencia, compra y mejora de personajes.
Los personajes tienen atributos como puntos de ataque, puntos de armadura, y se pueden equipar con hasta tres armas diferentes.
Los propietarios de personajes pueden ponerlos en venta y establecer precios de venta.

- Contrato Weapon:

Este contrato gestiona la creación, transferencia de las armas.
Las armas pueden ser poseídas por personajes y equipadas desde este contrato.


### Errores conocidos

- El require del allowance en los contratos de character y de weapon no quedaron implementados.
  

## Diagrama del proyecto

![Alt text](<Captura de pantalla 2023-11-30 a la(s) 17.08.13.png>)

Para un diagrama mas detallado:
https://drive.google.com/file/d/1G9mo3vzLXgGcXj_GnnwxDneKImphGFiZ/view?usp=sharing
  

## Pasos para hacer el setup del repositorio

- clonar repositorio

- instalar los modulos (npm install)

- probar los test (npm run test)

## Pasos para hacer el Deploy del proyecto

- clonar repositorio

- instalar los modulos del proyecto (npm install)

- instalar los modulos de frontend (cd crypto-web, npm install)

- configurar url y account en hardhat.config.js

- ejecutar script de deploy (npm run deploy)

- configurar las addresses de los contracts en crypto-web/src/addresses.js

- ejecutar deploy del frontend (cd crypto-web, vercel --prod)

## Mateo Giraz (241195) - Joaquin Rodríguez (231355) - Santiago Villar (256345)
