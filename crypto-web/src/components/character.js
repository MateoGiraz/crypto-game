import { ethers } from 'ethers';
import { useState, useEffect } from 'react';
import { characterAbi } from '../abi/characterAbi';
import { characterAddress, experienceAddress } from '../addresses';
import { experienceAbi } from '../abi/experienceAbi';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

export default function Character() {
  const [mintPrice, setMintPrice] = useState('');
  const [supply, setSupply] = useState('');
  const [URI, setURI] = useState('');
  const [symbol, setSymbol] = useState('');
  const [mintingName, setMintingName] = useState('');
  const [hasCharacter, setHasCharacter] = useState(false);
  const [name, setName] = useState('');
  const [attackPoints, setAttackPoints] = useState('')
  const [armorPoints, setArmorPoints] = useState('')
  const [weapon, setWeapon] = useState('')
  const [sellPrice, setsellPrice] = useState('');
  const [experienceNumber, setExperienceNumber] = useState('');

  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner();
  const characterContract = new ethers.Contract(
    characterAddress,
    characterAbi,
    signer
  );
  const experiencerContract = new ethers.Contract(
    experienceAddress,
    experienceAbi,
    signer
  );

  const notify = (message) => toast.success(message);
  const notifyError = (message) => toast.error(message);

  useEffect(() => {
    const fetchMintPrice = async () => {
      try {
        const mintPrice = await characterContract.mintPrice();
        setMintPrice(mintPrice.toString());
      } catch (error) {
        console.error('Error fetching mintPrice:', error);
      }
    };

    const fetchCharacters = async () => {
      try {
        const address = await signer.getAddress();
        const balance = await characterContract.balanceOf(address);
        if (parseInt(balance.toString()) > 0) {
          setHasCharacter(true);
          const filter = characterContract.filters.Transfer(null, address);

          const fromBlock = 0;
          const toBlock = 'latest';

          const logs = await characterContract.queryFilter(
            filter,
            fromBlock,
            toBlock
          );

          const lastLog = logs[logs.length - 1];
          const { _value } = lastLog.args;
          const { name, attackPoints, armorPoints, weapon, sellPrice } =
            await characterContract.metadataOf(_value.toString());

          setArmorPoints(armorPoints.toString());
          setWeapon(weapon.map(elem => elem.toString() != "0" ? elem.toString() + " - " : ''));
          setsellPrice(sellPrice.toString());
          setName(name.toString());
          setAttackPoints(attackPoints.toString());
        }
      } catch (error) {
        console.error('Error fetching characters:', error);
      }
    };

    const fetcTotalSupply = async () => {
      try {
        const totalSupply = await characterContract.totalSupply();
        setSupply(totalSupply.toString());
      } catch (error) {
        console.error('Error fetching name:', error);
      }
    };

    const fetchURI = async () => {
      try {
        const URI = await characterContract.tokenURI();
        setURI(URI.toString());
      } catch (error) {
        console.error('Error fetching name:', error);
      }
    };

    const fetchSymbol = async () => {
      try {
        const symbol = await characterContract.symbol();
        setSymbol(symbol.toString());
      } catch (error) {
        console.error('Error fetching name:', error);
      }
    };

    fetchCharacters();
    fetchMintPrice();
    fetcTotalSupply();
    fetchURI();
    fetchSymbol();
  }, []);

  const mintCharacter = async () => {
    try {
      if (mintingName === '') return;

      const options = {
        gasLimit: 3000000,
      };

      await characterContract.safeMint(mintingName, options);

      setMintingName('');
      notify('Minted successfully!');
    } catch (error) {
      notifyError('Error minting:', error);
    }
  };

  const buyExperience = async () => {
    try {
      if(experienceNumber === 0) 
        return;
      
      const options = {
        gasLimit: 3000000,
      };

      await experiencerContract.buy(
        experienceNumber,
        options
      );

      setExperienceNumber(0);
      notify('Tokens purchased successfully!');
    } catch (error) {
      notifyError('Error buying tokens:', error);
    }
  };

  return (
    <div class={`flex flex-col w-full h-full justify-center ${hasCharacter ? 'pb-0' : 'pb-20'}`}>
      <main class="flex flex-col items-center gap-4 p-4 md:gap-8 md:p-10 500">
        <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4 500">
          <div
            class="rounded-lg border bg-card text-card-foreground shadow-sm"
            data-v0-t="card"
          >
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
              <div className="text-2xl font-bold overflow-hidden whitespace-nowrap text-gray-800 dark:text-gray-300">
                {mintPrice}
              </div>
            </div>
          </div>
          <div
            class="rounded-lg border bg-card text-card-foreground shadow-sm"
            data-v0-t="card"
          >
            <div class="p-6 flex flex-row items-center justify-between pb-2 space-y-0">
              <h3 class="tracking-tight text-sm font-medium pr-2">
                Total Collection Supply
              </h3>
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
          <div
            class="rounded-lg border bg-card text-card-foreground shadow-sm"
            data-v0-t="card"
          >
            <div class="p-6 flex flex-row items-center justify-between pb-2 space-y-0">
              <h3 class="tracking-tight text-sm font-medium">
                Collection Symbol
              </h3>
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
          <div
            class="rounded-lg border bg-card text-card-foreground shadow-sm"
            data-v0-t="card"
          >
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
          {!hasCharacter && (
            <form class="w-full ml-auto flex flex-wrap">
              <div class="w-full md:w-1/2 p-2">
                <input
                  class="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 w-full"
                  placeholder="Character's name..."
                  type="text"
                  value={mintingName}
                  onChange={(e) => setMintingName(e.target.value)}
                />
              </div>
              <div class="w-full md:w-1/2 p-2">
                <button
                  onClick={mintCharacter}
                  class=" inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-indigo-500 text-primary-foreground hover:bg- h-10 px-4 py-2 w-full text-white"
                  type="button"
                >
                  Mint Character
                </button>
              </div>
            </form>
          )}
          {hasCharacter && (
            <div
              class="border text-card-foreground flex md:flex-row bg-white rounded-xl shadow-md overflow-hidden md:max-w-2xl m-3 p-3 dark:bg-gray-800"
              data-v0-t="card"
            >
              <div class="flex-grow">
                <div class="flex-col space-y-1.5 p-6 flex justify-between items-center">
                  <h3 class="tracking-tight text-lg font-semibold">
                    {name}
                  </h3>
                  <div class="text-gray-700 dark:text-gray-300 pb-2">
                    Price: ${sellPrice}
                  </div>
                  <div class="flex space-x-2">
                    <div class="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2">
                      Attack: {attackPoints}
                    </div>
                    <div class="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2">
                      Armor: {armorPoints}
                    </div>
                  </div>
                </div>
                <div class="border-t border-gray-200 dark:border-gray-600 p-3">
                  <h3 class="text-gray-700 dark:text-gray-300">WeaponIds: - {weapon ?? "none"} </h3>
                  <div class="flex flex-wrap gap-2"></div>
                </div>
              </div>
              <div class="border-l border-gray-200 dark:border-gray-600 p-3 flex flex-col justify-center items-center md:items-center">
              <input
              class="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 w-3/4"
              placeholder="XP to buy..."
              type="number"
              value={experienceNumber}
              onChange={(e) => setExperienceNumber(e.target.value)}
            />
                <button onClick={buyExperience} class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 mt-4 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-indigo-500 text-white text-secondary-foreground hover:bg-secondary/80 h-10 px-3 py-2 w-3/4">
                  Buy Experience
                </button>
              </div>
            </div>
          )}
        </div>
      </main>
      <ToastContainer />
    </div>
  );
}
