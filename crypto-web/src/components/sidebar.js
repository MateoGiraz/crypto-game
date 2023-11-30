export default function Sidebar({option, setOption, screens}) {
  const handleButtonClick = (index) => {
    setOption(index);
  };

  return (
    <div className="h-full w-64 pt-4 pl-2 border-r-2">
      <nav className="flex flex-col p-4">
        <button className="flex items-center gap-2 my-4" href="#" onClick={() => handleButtonClick(screens.Rubie)}>
          <IconRubie className={`h-6 w-6 ${option === screens.Rubie ? 'text-indigo-500' : 'text-gray-500'}`} />
          <span className="font-semibold">Rubie</span>
        </button>
        <button className="flex items-center gap-2 mt-6 mb-4" href="#" onClick={() => handleButtonClick(screens.Weapon)}>
          <IconWeapon className={`h-6 w-6 ${option === screens.Weapon ? 'text-indigo-500' : 'text-gray-500'}`} />
          <span className="font-semibold">Weapon</span>
        </button>
        <button className="flex items-center gap-2 mt-6" href="#" onClick={() => handleButtonClick(screens.Character)}>
          <IconCharacter className={`h-6 w-6 ${option === screens.Character ? 'text-indigo-500' : 'text-gray-500'}`} />
          <span className="font-semibold">Character</span>
        </button>
      </nav>
    </div>
  )
}

function IconCharacter(props) {
  return (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
      <circle cx="12" cy="7" r="4" />
    </svg>
  )
}


function IconRubie(props) {
  return (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="M6 3h12l4 6-10 13L2 9Z" />
      <path d="M11 3 8 9l4 13 4-13-3-6" />
      <path d="M2 9h20" />
    </svg>
  )
}


function IconWeapon(props) {
  return (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <polyline points="14.5 17.5 3 6 3 3 6 3 17.5 14.5" />
      <line x1="13" x2="19" y1="19" y2="13" />
      <line x1="16" x2="20" y1="16" y2="20" />
      <line x1="19" x2="21" y1="21" y2="19" />
    </svg>
  )
}