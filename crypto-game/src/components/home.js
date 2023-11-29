'use client';
import Header from "./header";
import Rubie from "./rubie";
import Sidebar from "./sidebar";
import { useState } from 'react';
import Weapon from "./weapon";
import Character from "./character";

export default function Home(){

  const [option, setOption] = useState(0)

  const screens = {
    'Rubie': 0,
    'Weapon': 1,
    'Character': 2
  }

  return(
    <div class="h-full w-full grid h-screen place-items-center ">
      <div class="w-full h-full md:w-3/4 md:h-3/4 block bg-white border border-gray-200 rounded-lg shadow overflow-none">
        <Header/>
        <div class="flex h-[calc(100%_-_80px)] w-full">
          <Sidebar option={option} setOption={setOption} screens={screens}/>
          <div class="h-full w-full">
            {option == screens.Rubie && <Rubie/>}
            {option == screens.Weapon && <Weapon/>}
            {option == screens.Character && <Character/>}
          </div>
        </div>
      </div>
    </div>
  )
}