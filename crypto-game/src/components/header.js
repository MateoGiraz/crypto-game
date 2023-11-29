export default function Header() {
  return (
    <div className="flex items-center justify-between px-6 py-4 bg-indigo-500 text-white rounded-t-lg h-[80px]">
      <div className="flex items-center space-x-4">
        <IconWallet className="h-6 w-6" />
        <div>
          <h2 className="text-lg font-semibold">Token Balance</h2>
          <p className="text-sm">1234 Token</p>
        </div>
      </div>
      <div className="flex items-center space-x-4">
        <IconStar className="h-6 w-6" />
        <div>
          <h2 className="text-lg font-semibold">Experience</h2>
          <p className="text-sm">5678 XP</p>
        </div>
      </div>
      <div className="flex items-center space-x-4">
        <IconSword className="h-6 w-6" />
        <div>
          <h2 className="text-lg font-semibold">Total Weapons</h2>
          <p className="text-sm">9 Weapons</p>
        </div>
      </div>
      <div className="flex items-center space-x-4">
        <IconUser className="h-6 w-6" />
        <div>
          <h2 className="text-lg font-semibold">Total Characters</h2>
          <p className="text-sm">10 Characters</p>
        </div>
      </div>
    </div>
  )
}

function IconStar(props) {
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
      <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
    </svg>
  )
}


function IconSword(props) {
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


function IconUser(props) {
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


function IconWallet(props) {
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
      <path d="M21 12V7H5a2 2 0 0 1 0-4h14v4" />
      <path d="M3 5v14a2 2 0 0 0 2 2h16v-5" />
      <path d="M18 12a2 2 0 0 0 0 4h4v-4Z" />
    </svg>
  )
}