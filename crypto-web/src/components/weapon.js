import { ethers } from 'ethers';
import { useState, useEffect } from 'react';
import { characterAbi } from '../abi/characterAbi';
import { weaponAbi } from '../abi/weaponAbi';
import { weaponAddress } from '../addresses';

export default function Weapon(){
  const [mintPrice, setMintPrice] = useState('');
  const [supply, setSupply] = useState('');
  const [URI, setURI] = useState('');
  const [symbol, setSymbol] = useState('');
  const [mintingName, setMintingName] = useState('');

  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner();
  const weaponContract = new ethers.Contract(weaponAddress, weaponAbi, signer)

  useEffect(() => {
    const fetchMintPrice = async () => {
      try {
        const mintPrice = await weaponContract.mintPrice();
        setMintPrice(mintPrice.toString());
      } catch (error) {
        console.error('Error fetching mintPrice:', error);
      }
    };

    const fetcTotalSupply = async () => {
      try {
        const totalSupply = await weaponContract.totalSupply();
        setSupply(totalSupply.toString());
      } catch (error) {
        console.error('Error fetching name:', error);
      }
    };

    const fetchURI = async () => {
      try {
        const URI = await weaponContract.tokenURI();
        setURI(URI.toString());
      } catch (error) {
        console.error('Error fetching name:', error);
      }
    };

    const fetchSymbol = async () => {
      try {
        const symbol = await weaponContract.symbol();
        setSymbol(symbol.toString());  
      } catch (error) {
        console.error('Error fetching name:', error);
      }
    };

    fetchMintPrice();
    fetcTotalSupply();
    fetchURI();
    fetchSymbol();
  }, []);

  const mintWeapon = async () => {
    try {
      if(mintingName === "") 
        return;

      console.log('Minting ' + mintingName + '...');  

      const options = {
        gasLimit: 3000000,
      };

      await weaponContract.safeMint(
        mintingName,
        options
      );

      setMintingName("");
      console.log('Minted successfully!');
    } catch (error) {
      console.error('Error minting:', error);
    }
  };

  return(
    <div class="flex flex-col w-full h-full justify-center pb-20">
    <main class="flex flex-col items-center gap-4 p-4 md:gap-8 md:p-10 500">
      <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4 500">
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm" data-v0-t="card">
          <div class="p-6 flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 class="tracking-tight text-sm font-medium">Minting Price</h3>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="w-4 h-4 text-gray-500 dark:text-gray-400"
            >
              <line x1="12" x2="12" y1="2" y2="22"></line>
              <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
            </svg>
          </div>
          <div class="p-6">
          <div className="text-2xl font-bold overflow-hidden whitespace-nowrap text-gray-800 dark:text-gray-300">{mintPrice}</div>
          </div>
        </div>
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm" data-v0-t="card">
          <div class="p-6 flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 class="tracking-tight text-sm font-medium pr-2">Total Collection Supply</h3>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="w-4 h-4 text-gray-500 dark:text-gray-400"
            >
              <line x1="4" x2="20" y1="9" y2="9"></line>
              <line x1="4" x2="20" y1="15" y2="15"></line>
              <line x1="10" x2="8" y1="3" y2="21"></line>
              <line x1="16" x2="14" y1="3" y2="21"></line>
            </svg>
          </div>
          <div class="p-6">
            <div class="text-2xl font-bold">{supply}</div>
          </div>
        </div>
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm" data-v0-t="card">
          <div class="p-6 flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 class="tracking-tight text-sm font-medium">Collection Symbol</h3>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="w-4 h-4 text-gray-500 dark:text-gray-400"
            >
              <line x1="4" x2="20" y1="9" y2="9"></line>
              <line x1="4" x2="20" y1="15" y2="15"></line>
              <line x1="10" x2="8" y1="3" y2="21"></line>
              <line x1="16" x2="14" y1="3" y2="21"></line>
            </svg>
          </div>
          <div class="p-6">
            <div class="text-2xl font-bold">{symbol}</div>
          </div>
        </div>
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm" data-v0-t="card">
          <div class="p-6 flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 class="tracking-tight text-sm font-medium">Collection URI</h3>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="w-4 h-4 text-gray-500 dark:text-gray-400"
            >
              <line x1="4" x2="20" y1="9" y2="9"></line>
              <line x1="4" x2="20" y1="15" y2="15"></line>
              <line x1="10" x2="8" y1="3" y2="21"></line>
              <line x1="16" x2="14" y1="3" y2="21"></line>
            </svg>
          </div>
          <div class="p-6">
            <div class="text-2xl font-bold">{URI}</div>
          </div>
        </div>
      </div>
      <div class="flex flex-col md:flex-row gap-4 md:gap-8 ">
        <form class="w-full ml-auto flex flex-wrap">
          <div class="w-full md:w-1/2 p-2">
            <input
              class="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 w-full"
              placeholder="Weapon's name..."
              type="text"
              value={mintingName}
              onChange={(e) => setMintingName(e.target.value)}
            />
          </div>
          <div class="w-full md:w-1/2 p-2">
            <button
              onClick={mintWeapon}
              class=" inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-indigo-500 text-primary-foreground hover:bg- h-10 px-4 py-2 w-full text-white"
              type="button"
            >
              Mint Weapon
            </button>
          </div>
        </form>
      </div>
    </main>
  </div>
  )
}
