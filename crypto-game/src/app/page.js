'use client';
import { useState, useEffect } from 'react';
import detectEthereumProvider from '@metamask/detect-provider';
import Home from '@/components/home';

export default function Component() {
  const [hasProvider, setHasProvider] = useState(false);
  const [wallet, setWallet] = useState(null);

  useEffect(() => {
    const refreshAccount = (account) => {
      if (account != null) {
        setWallet(account);
      } else {
        setWallet(null);
      }
    };

    const getProvider = async () => {
      const provider = await detectEthereumProvider();
      setHasProvider(provider);

      if (provider) {
        const account = await window.ethereum.request({
          method: 'eth_accounts',
        });
        refreshAccount(account[0]);
        window.ethereum.on('accountsChanged', refreshAccount);
      }
    };

    getProvider();
  }, []);

  const handleConnect = async () => {
    let account = await window.ethereum.request({
      method: 'eth_requestAccounts',
    });
    setWallet(account);
  };

  return (
    <div class="w-full h-full">
      {wallet == null &&           
      <div class="w-full h-full grid h-screen place-items-center">
        <div
          class="rounded-lg border-2 bg-card text-card-foreground shadow-sm mx-auto max-w-sm p-6 space-y-4 text-center mb-20 border-solid"
          data-v0-t="card"
        >
          <div class="flex flex-col p-6 space-y-2">
            <h3 class="tracking-tight text-2xl font-bold">
              Connect to MetaMask
            </h3>
            <p class="text-sm text-muted-foreground">
              Click the button below to connect your MetaMask wallet.
            </p>
          </div>
          <button
            onClick={handleConnect}
            class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:text-accent-foreground h-10 px-4 py-2 w-full hover:bg-gray-200 dark:hover:bg-gray-800 transition-colors"
          >
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
              class="mr-2 h-6 w-6"
            >
              <path d="M21 12V7H5a2 2 0 0 1 0-4h14v4" />
              <path d="M3 5v14a2 2 0 0 0 2 2h16v-5" />
              <path d="M18 12a2 2 0 0 0 0 4h4v-4Z" />
            </svg>
            Connect to MetaMask
          </button>
        </div>
        </div>
      }

      {wallet != null && <Home/>}
    </div>
  );
}
