[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/B8-f4DG0)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=12461672&assignment_repo_type=AssignmentRepo)

# Obligatorio de Taller de Tecnologías 2 - Gaming Platform

## Integrantes del equipo: Mateo Giraz (241195) - Joaquin Rodríguez (231355) - Santiago Villar (256345)
### Grupo M6C- Profesor: Itay Brenner, German Trautman

### [Enlace al repositorio](https://github.com/TallerTecnologias2/obligatorio-2023-02-giraz-rodriguez-villar-1)
### [Video presentando el obligatorio realizado](https://www.youtube.com/watch?v=CBhjbTMVV1Q&ab_channel=MateoGiraz)
Tuvimos problemas a la hora de grabar el video por lo que el resultado no tiene la mejor calidad (se ve trancado). En vista de la cercanía a la entrega, solo pudimos volver a grabar la demo de frontend, que es la última parte del video. En el video se comenta el uso de GitFlow y buenas practicas alrededor del repositorio, se muestran los commits, pull requests y actions de GitHub. Tabmién se muestran buenas prácticas de código y se enseña el script de deploy. Finalmente se muestra el frontend y sus funcionalidades.
### [Demo frontend](https://crypto.giraz.xyz/)
## Descripción de proyecto:

El proyecto consta de una Dapp con las interfaces proporcionadas implementadas en solidity y un frontend en react (Version 17.02).
El proyecto consta de un ecosistema de contratos inteligentes destinados a gestionar una plataforma gaming usando Blockchain, token fungibles y NFTs.

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

### Address de los contratos

OwnersContract: ```0x4EE71De305f162448C1E7F1DA0CC2060aD301bAe```
<br/>
Experience: ```0x127d2c578d482B4568D619163e87a30AEdE9d1dD```
<br/>
Rubie: ```0xD74eF0D24b65750528B92d49fA9d9E916D3d642B```
<br/>
Character: ```0x0ae412486660729647553C2De78F662c2e2D3128```
<br/>
Weapon: ```0x13295abbCD72c872a200c1a55E519d5b1fcc8d50```

### Errores conocidos

- El require del allowance en los contratos de character y de weapon no quedaron implementados.
- No se implementa el siguiente dev
 @dev When transfer is complete, this function checks if `_to` is a smart contract (code size > 0), 
 if so, it calls `onERC721Received` on `_to` and throws if the return value is not 

## Diagrama del proyecto

![Alt text](<Captura de pantalla 2023-11-30 a la(s) 17.08.13.png>)

Para un diagrama mas detallado:
[Diagrama UML](https://viewer.diagrams.net/?tags=%7B%7D&highlight=0000ff&edit=_blank&layers=1&nav=1&title=UML-Taller.drawio#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1G9mo3vzLXgGcXj_GnnwxDneKImphGFiZ%26export%3Ddownload)
  

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

## Desarrollo del obligatorio

Tras haber desarrollado nuestro obligatorio podemos destacar aspectos de nuestro desarrollo:

- Implementamos una pipeline de CI para poder tener feedback sobre nuestros tests y poder mergear nuestras branches con seguridad.
  
- Uso de modifiers: Para los requerimientos de cada función utilizamos modifiers, ya que notamos que muchas funciones tenían varios require en común. De esta forma obtenemos un código reutilizable y un contrato más limpio

- Creación de funciones auxiliares: Creamos las funciones auxiliares que nos parecieron necesarias para implementar las interfaces en cada contrato, asegurándonos de que estas solo puedan ser llamadas por los contratos especificos.

- Creación de tests: Hicimos tests para cada contrato, con el fin de garantizar que al hacer cambios en el código no se esté rompiendo ninguna funcionalidada. En la siguiente imagen podemos observar los tests realizados:
<img width="367" alt="image" src="https://github.com/TallerTecnologias2/obligatorio-2023-02-giraz-rodriguez-villar-1/assets/91506401/34b2a667-ac47-4a00-bbc7-410fcd61ca64">

