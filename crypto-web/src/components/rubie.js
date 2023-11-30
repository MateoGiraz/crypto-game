import { ethers } from 'ethers';
import { rubieAbi } from '../abi/RubieAbi';
import { useState, useEffect } from 'react';
import { rubieAddress } from '../addresses';

export default function Rubie(){
  const [price, setPrice] = useState('');
  const [supply, setSupply] = useState('');
  const [decimals, setDecimals] = useState('');
  const [symbol, setSymbol] = useState('');
  const [numberOfTokens, setNumberOfTokens] = useState('');

  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner();
  const rubieContract = new ethers.Contract(rubieAddress, rubieAbi, signer)

  useEffect(() => {
    const fetchPrice = async () => {
      try {
        const price = await rubieContract.price();
        setPrice(price.toString());
      } catch (error) {
        console.error('Error fetching price:', error);
      }
    };

    const fetcTotalSupply = async () => {
      try {
        const totalSupply = await rubieContract.totalSupply();
        setSupply(totalSupply.toString());
      } catch (error) {
        console.error('Error fetching price:', error);
      }
    };

    const fetchDecimals = async () => {
      try {
        const decimals = await rubieContract.decimals();
        setDecimals(decimals.toString());
      } catch (error) {
        console.error('Error fetching price:', error);
      }
    };

    const fetchSymbol = async () => {
      try {
        const symbol = await rubieContract.symbol();
        setSymbol(symbol.toString());  
      } catch (error) {
        console.error('Error fetching price:', error);
      }
    };

    fetchPrice();
    fetcTotalSupply();
    fetchDecimals();
    fetchSymbol();
  }, []);

  const buyTokens = async () => {
    try {
      if(numberOfTokens === 0) 
        return;

      console.log('Buying ' + numberOfTokens + ' tokens...');  
      
      const options = {
        gasLimit: 3000000,
        value: ethers.utils.parseUnits((price * numberOfTokens)+"", "wei"),
      };

      await rubieContract.buy(
        numberOfTokens,
        options
      );

      setNumberOfTokens(0);
      console.log('Tokens purchased successfully!');
    } catch (error) {
      console.error('Error buying tokens:', error);
    }
  };

  return(
    <div class="flex flex-col w-full h-full justify-center pb-20">
    <main class="flex flex-col items-center gap-4 p-4 md:gap-8 md:p-10 500">
      <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4 500">
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm" data-v0-t="card">
          <div class="p-6 flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 class="tracking-tight text-sm font-medium">Current Token Price</h3>
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
              class="w-4 h-4 text-gray-500 "
            >
              <line x1="12" x2="12" y1="2" y2="22"></line>
              <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
            </svg>
          </div>
          <div class="p-6">
          <div className="text-2xl font-bold overflow-hidden whitespace-nowrap text-gray-800">{price} x 10⁻¹⁸</div>
          </div>
        </div>
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm" data-v0-t="card">
          <div class="p-6 flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 class="tracking-tight text-sm font-medium">Total Token Supply</h3>
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
              class="w-4 h-4 text-gray-500"
            >
              <path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"></path>
              <path d="m3.3 7 8.7 5 8.7-5"></path>
              <path d="M12 22V12"></path>
            </svg>
          </div>
          <div class="p-6">
            <div class="text-2xl font-bold">{supply}</div>
          </div>
        </div>
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm" data-v0-t="card">
          <div class="p-6 flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 class="tracking-tight text-sm font-medium">Token Symbol</h3>
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
              class="w-4 h-4 text-gray-500"
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
            <h3 class="tracking-tight text-sm font-medium">Token Decimals</h3>
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
              class="w-4 h-4 text-gray-500"
            >
              <line x1="4" x2="20" y1="9" y2="9"></line>
              <line x1="4" x2="20" y1="15" y2="15"></line>
              <line x1="10" x2="8" y1="3" y2="21"></line>
              <line x1="16" x2="14" y1="3" y2="21"></line>
            </svg>
          </div>
          <div class="p-6">
            <div class="text-2xl font-bold">{decimals}</div>
          </div>
        </div>
      </div>
      <div class="flex flex-col md:flex-row gap-4 md:gap-8 ">
        <form class="w-full ml-auto flex flex-wrap">
          <div class="w-full md:w-1/2 p-2">
            <input
              class="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 w-full"
              placeholder="Number of tokens..."
              type="number"
              value={numberOfTokens}
              onChange={(e) => setNumberOfTokens(e.target.value)}
            />
          </div>
          <div class="w-full md:w-1/2 p-2">
            <button
              onClick={buyTokens}
              class=" inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-indigo-500 text-primary-foreground hover:bg- h-10 px-4 py-2 w-full text-white"
              type="button"
            >
              Purchase Tokens
            </button>
          </div>
        </form>
      </div>
    </main>
  </div>
  )
}
