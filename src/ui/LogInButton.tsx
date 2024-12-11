'use client';
import { useState } from "react";
import { userSession } from "@/lib/Wallet";
import { showConnect, disconnect, AuthResponsePayload } from "@stacks/connect";
import clsx from 'clsx';

const myAppName = 'Testing functions';

export const LogInButton = () => {
  const [connected, setConnected] = useState(false);
  const [userData, setUserData] = useState<AuthResponsePayload | null>(null);
  const signIn = () => {
    showConnect({
      appDetails: {
        name: myAppName,
        icon: 'https://cdn-icons-png.flaticon.com/512/10061/10061823.png',
      },
      userSession,
      redirectTo: '/',
      onFinish: (payload) => {
        console.log(payload);
        setConnected(true);
        setUserData(payload.authResponsePayload);
      },
      onCancel: () => {
        window.alert('Authentication was cancelled');
      }
    });
  };
  const logOut = () => {
    disconnect();
    setConnected(false);
  }
  return (
    <div className="w-full">
      {connected ? (<div>Testnet: {userData?.profile.stxAddress.testnet.slice(0,5) + "..." + userData?.profile.stxAddress.testnet.slice(-5)}</div>) : null}
      {connected ? (<div>Mainnet: {userData?.profile.stxAddress.mainnet.slice(0,5) + "..." + userData?.profile.stxAddress.mainnet.slice(-5)}</div>) : null}
      {connected ? (
        <div className="button-wrapper flex items-center w-full">
          <button type="button" onClick={logOut} className="w-1/2 text-white bg-green-500 mt-2 p-2 rounded dark:bg-green-700">
            Disconnect wallet
          </button>
        </div>
      ) : (
        <div className="button-wrapper flex flex-col items-center w-full">
          <button type="button" onClick={signIn} className="w-1/2 text-white bg-orange-500 p-2 dark:bg-orange-700 rounded ">
            Log in with Stacks
          </button>
        </div>
      )}
    </div>
  );
};