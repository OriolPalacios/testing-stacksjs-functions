'use client';
import { useState } from "react";
import { userSession } from "@/lib/Wallet";
import { showConnect, disconnect, AuthResponsePayload } from "@stacks/connect";
import clsx from 'clsx';

const myAppName = 'Testing functions';
const buttonClass = clsx('button', {
  'button--disabled': !userSession.isUserSignedIn()
});

export const LogInButton = () => {
  const [connected, setConnected] = useState(false);
  const [userData, setUserData] = useState<AuthResponsePayload | null>(null);
  const signIn = () => {
    showConnect({
      appDetails: {
        name: myAppName,
        icon: window.location.origin + '/logo.svg',
      },
      userSession,
      redirectTo: '/',
      onFinish: (payload) => {
        console.log(payload);
        setConnected(true);
        setUserData(payload.authResponsePayload);
        // window.location.reload();
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
      {connected ? (<div>Hola {userData?.profile.stxAddress.testnet}</div>) : null}
      {connected ? (<div>Hola {userData?.profile.stxAddress.mainnet}</div>) : null}
      {connected ? (
        <div className="button-wrapper flex flex-col items-center w-full">
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